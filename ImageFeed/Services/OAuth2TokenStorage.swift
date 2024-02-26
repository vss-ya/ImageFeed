//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by vs on 08.02.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    private let tokenKey = "OAuth2BearerToken"
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            if let newValue = newValue {
                let isSuccess = KeychainWrapper.standard.set(newValue, forKey: tokenKey)
                assert(isSuccess)
            }
        }
    }
    
}
