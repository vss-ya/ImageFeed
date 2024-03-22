//
//  ImagesListViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by vs on 20.03.2024.
//

import ImageFeed
import Foundation

final class ImagesListPresenterSpy: ImagesListViewPresenterProtocol {
    var view: ImageFeed.ImagesListViewControllerProtocol?
    
    var imagesListService: ImageFeed.ImagesListService
    
    var viewDidLoadCalled = false
    var didSetLikeCall: Bool = false
    
    init(imagesListService: ImageFeed.ImagesListService = ImageFeed.ImagesListService.shared ) {
        self.imagesListService = imagesListService
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func fetchPhotosNextPage() {
        
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        didSetLikeCall = true
    }
    
}
