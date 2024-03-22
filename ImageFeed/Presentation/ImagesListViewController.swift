//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by vs on 11.01.2024.
//

import UIKit
import Kingfisher

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListViewPresenterProtocol? { get set }
    var photos: [Photo] {get set}
    func imagesListDidChange()
}

final class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private let singleImageSegueIdentifier = "SingleImage"
    private let placeholderImage = UIImage(named: "placeholder_stub")
    internal var photos: [Photo] = []
    
    lazy var presenter: ImagesListViewPresenterProtocol? = {
        return ImagesListViewPresenter()
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepare()
        
        UIBlockingProgressHUD.show()
        presenter?.view = self
        presenter?.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == singleImageSegueIdentifier {
            guard let vc = segue.destination as? SingleImageViewController else {
                assertionFailure("Invalid Configuration")
                return
            }
            let indexPath = sender as! IndexPath
            let photo = photos[indexPath.row]
            vc.imageURL = photo.fullImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
}

extension ImagesListViewController: ImagesListViewControllerProtocol {
    
    func imagesListDidChange() {
        UIBlockingProgressHUD.dismiss()
        updateTableViewAnimated()
    }
    
}

// MARK: - Helpers
extension ImagesListViewController {
    
    private func prepare() {
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        func formattedDateString(_ date: Date?) -> String {
            guard let date else { return "" }
            return dateFormatter.string(from: date)
        }
        let photo = photos[indexPath.row]
        guard let imageURL = URL(string: photo.thumbImageURL) else {
            return
        }
        let likeImage = photo.isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        let dateString = formattedDateString(photo.createdAt)
        
        cell.delegate = self
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: imageURL,
                                   placeholder: placeholderImage)
        { [weak self](result) in
            guard let self else {
                return
            }
            switch result {
            case .success(_):
                cell.likeButton.setImage(likeImage, for: .normal)
                cell.dateLabel.text = dateString
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure(let error):
                Logger.logError(message: error.localizedDescription)
            }
        }
    }
    
    @objc private func updateTableViewAnimated() {
        guard let imagesListService = presenter?.imagesListService else {
            return
        }
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
    
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !ProcessInfo.processInfo.arguments.contains("testMode") else {
            return
        }
        if indexPath.row + 1 == photos.count {
            UIBlockingProgressHUD.show()
            presenter?.fetchPhotosNextPage()
        } else {
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = placeholderImage else {
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: singleImageSegueIdentifier, sender: indexPath)
    }
    
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard 
            let indexPath = tableView.indexPath(for: cell),
            let presenter = presenter else
        {
            return
        }
        let photo = photos[indexPath.row]
        let isLiked = !photo.isLiked
        UIBlockingProgressHUD.show()
        presenter.changeLike(photoId: photo.id, isLike: isLiked) { [weak self](result) in
            guard let self else {
                return
            }
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
                
                switch result {
                case .success:
                    cell.setIsLiked(isLiked)
                    guard let index = self.photos.firstIndex(where: { $0.id == photo.id }) else {
                        return
                    }
                    let currentPhoto = self.photos[index]
                    let updatedPhoto = Photo(
                        id: currentPhoto.id,
                        size: currentPhoto.size,
                        createdAt: currentPhoto.createdAt,
                        welcomeDescription: currentPhoto.welcomeDescription,
                        thumbImageURL: currentPhoto.thumbImageURL,
                        largeImageURL: currentPhoto.largeImageURL,
                        fullImageURL: currentPhoto.fullImageURL,
                        isLiked: !currentPhoto.isLiked
                    )
                    self.photos[index] = updatedPhoto
                case .failure(let error):
                    Logger.logError(message: "\(error.localizedDescription)")
                }
            }
        }
    }
    
}
