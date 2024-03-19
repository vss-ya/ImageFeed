//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by vs on 20.03.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {

    let email = "vss.direct@gmail.com"
    let password = "qwerty123456"
    let fullname = "Qeq Asd"
    let username = "@vss_direct"
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launchArguments = ["testMode"]
        app.launch()
        
    }
    
    func testAuth() throws {
        sleep(3)
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText(email)
        webView.tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText(password)
        webView.swipeUp()
        sleep(3)
        
        webView.buttons["Login"].tap()
        
        sleep(3)
        
        let tablesQuery = app.tables
        let cell = tablesQuery.descendants(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        sleep(3)
        let tables = app.tables
        
        let cell = tables.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(3)
        
        let cellToLike = tables.descendants(matching: .cell).element(boundBy: 1)
        
        let likeButton = cellToLike.buttons.element(matching: .button, identifier: "Like")
        
        likeButton.tap()
        
        sleep(2)
        
        likeButton.tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        sleep(3)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        image.pinch(withScale: 3, velocity: 1)
        
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["nav_back_button_white"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(5)
        app.tabBars.buttons.element(matching: .button, identifier: "Profile").tap()
        sleep(5)
        XCTAssertTrue(app.staticTexts[fullname].exists)
        XCTAssertTrue(app.staticTexts[username].exists)
        
        app.buttons["Logout"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        
        sleep(3)
        XCTAssertTrue(app.buttons["Authenticate"].exists)
    }
    
}
