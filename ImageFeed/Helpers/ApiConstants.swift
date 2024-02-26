//
//  ApiConstants.swift
//  ImageFeed
//
//  Created by vs on 07.02.2024.
//

import Foundation

enum ApiConstants {
    static let accessKey = "BPCuP8TNlI0w4hAqRXDEYjnykQAy-Z98qwBfGDmwHCE"
    static let secretKey = "V96_puGix8FeTbPU720_cOS4VXP1huo26jU8ekL3hik"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let oauth2BaseURL = URL(string: "https://unsplash.com/")!
    static let apiBaseURL = URL(string: "https://api.unsplash.com/")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
