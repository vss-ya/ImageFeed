//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by vs on 20.03.2024.
//

import ImageFeed
import Foundation

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    
    var presenter: ImageFeed.ImagesListViewPresenterProtocol?
    
    var photos: [ImageFeed.Photo] = []
    
    func imagesListDidChange() {
        
    }
    
    func imageListCellDidTapLike() {
        presenter?.changeLike(photoId: "", isLike: true, { result in
            
        })
    }
    
}
