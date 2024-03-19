//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by vs on 19.01.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    
    private(set) var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    var imageURL: String? {
        didSet {
            guard isViewLoaded else { return }
            loadImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        loadImage()
    }
    
}

// MARK: - Actions
extension SingleImageViewController {
    
    @IBAction private func backAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func shareAction(_ sender: UIButton) {
        let share = UIActivityViewController(
            activityItems: [image ?? UIImage()],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
}

// MARK: - Helpers
extension SingleImageViewController {
    
    private func prepare() {
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
    
    private func loadImage() {
        let url = URL(string: imageURL ?? "")
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: url) { [weak self](result) in
            UIBlockingProgressHUD.dismiss()
            guard let self else {
                return
            }
            switch result {
            case .success(let imageResult):
                self.image = imageResult.image
            case .failure:
                self.showError()
            }
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    func showError() {
        let title = "Ошибка"
        let message = "Что-то пошло не так. Попробовать ещё раз?"
        let okButtonText = "Не надо"
        let cancelButtonText = "Повторить"
        let ac = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: okButtonText, style: .default) { (_) in
            
        }
        let cancelAction = UIAlertAction(title: cancelButtonText, style: .cancel) { [weak self](_) in
            self?.loadImage()
        }
        ac.addAction(okAction)
        ac.addAction(cancelAction)
        ac.view.accessibilityIdentifier = ""
        present(ac, animated: true, completion: nil)
    }
    
}

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
}
