//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by vs on 20.03.2024.
//

import Foundation

public protocol ImagesListViewPresenterProtocol {
    
    var view: ImagesListViewControllerProtocol? { get set }
    var imagesListService: ImagesListService { get }
    func viewDidLoad()
    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
    
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    
    let imagesListService = ImagesListService.shared
    
    func viewDidLoad() {
        addObservers()
        fetchPhotosNextPage()
    }
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        imagesListService.changeLike(photoId: photoId, isLike: isLike) { (result) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                Logger.logError(message: "\(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(imagesListDidChange),
                                               name: ImagesListService.didChangeNotification,
                                               object: nil)
    }
    
    @objc private func imagesListDidChange() {
        view?.imagesListDidChange()
    }
    
}
