//
//  ImagesListViewTests.swift
//  ImageFeedTests
//
//  Created by vs on 20.03.2024.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
        
    func testViewControllerCallsViewDidLoad(){
        let imageListService = ImagesListService.shared
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenterSpy(imagesListService: imageListService)
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    
    func testPresenterDidSetLikeCall() {
        let photos: [Photo] = []
        let imagesListService = ImagesListService.shared
        let view = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy(imagesListService: imagesListService)
        view.presenter = presenter
        presenter.view = view
       
        view.imageListCellDidTapLike()
        
        XCTAssertTrue(presenter.didSetLikeCall)
    }
    
}
