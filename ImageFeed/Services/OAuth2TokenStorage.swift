//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by vs on 08.02.2024.
//

import Foundation

final class OAuth2TokenStorage {
    
    private let tokenKey = "OAuth2BearerToken"
    
    var token: String? {
        get { UserDefaults.standard.string(forKey: tokenKey) }
        set { UserDefaults.standard.set(newValue, forKey: tokenKey) }
    }
    
}
