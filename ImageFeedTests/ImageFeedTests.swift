//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by vs on 15.03.2024.
//

@testable import ImageFeed
import XCTest

final class ImageFeedTests: XCTestCase {
    
    func testFetchPhotos() {
        let service = ImagesListService.shared
        
        let expectation = self.expectation(description: "Wait for Notification")
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { _ in
                expectation.fulfill()
            }
        
        service.fetchPhotosNextPage()
        wait(for: [expectation], timeout: 10)
        
        XCTAssertEqual(service.photos.count, 10)
    }
    
}
