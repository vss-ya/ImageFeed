//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by vs on 08.02.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    private let keychainWrapper = KeychainWrapper.standard
    
    private let tokenKey = "OAuth2BearerToken"
    
    var token: String? {
        get {
            return keychainWrapper.string(forKey: tokenKey)
        }
        set {
            if let newValue = newValue {
                let isSuccess = keychainWrapper.set(newValue, forKey: tokenKey)
                assert(isSuccess)
            }
        }
    }
    
    func clean() {
        keychainWrapper.removeAllKeys()
    }
    
}
