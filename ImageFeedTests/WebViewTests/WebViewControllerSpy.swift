//
//  WebViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by vs on 19.03.2024.
//

import ImageFeed
import Foundation

final class WebViewControllerSpy: WebViewControllerProtocol {
    
    var presenter: WebViewPresenterProtocol?

    var loadRequestCalled: Bool = false

    func load(request: URLRequest) {
        loadRequestCalled = true
    }

    func setProgressValue(_ newValue: Float) {

    }

    func setProgressHidden(_ isHidden: Bool) {

    }
    
}
