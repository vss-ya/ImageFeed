//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by vs on 19.03.2024.
//

import Foundation

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: ApiConstants.accessKey,
                                 secretKey: ApiConstants.secretKey,
                                 redirectURI: ApiConstants.redirectURI,
                                 accessScope: ApiConstants.accessScope,
                                 authURLString: ApiConstants.unsplashAuthorizeURLString,
                                 defaultBaseURL: ApiConstants.apiBaseURL)
    }
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}
