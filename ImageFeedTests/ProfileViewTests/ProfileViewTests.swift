//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by vs on 19.03.2024.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) //behaviour verification
    }
    
    func testViewControllerCallsViewDidLogout() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        presenter.logout()
        
        //then
        XCTAssertTrue(presenter.didLogout) //behaviour verification
    }
    
    func testViewControllerCallsViewDidUpdateProfile() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertNotNil(viewController.profile)
        XCTAssertNotNil(viewController.avatarUrl)
    }
    
}
