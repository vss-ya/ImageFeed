//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by vs on 15.03.2024.
//

import Foundation

import WebKit
import SwiftKeychainWrapper

final class ProfileLogoutService {
    
    static let shared = ProfileLogoutService()
    
    private let keychainWrapper = KeychainWrapper.standard
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let imagesListService = ImagesListService.shared
    
    private init() { }
    
    func logout() {
        clean()
        switchToSplashViewController()
    }
    
    private func clean() {
        profileService.clean()
        profileImageService.clean()
        imagesListService.clean()
        
        keychainWrapper.removeAllKeys()
        cleanCookies()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func switchToSplashViewController() {
        let splashViewController = SplashViewController()
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        window.rootViewController = splashViewController
    }
    
}
