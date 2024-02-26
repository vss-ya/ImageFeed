//
//  UserResult.swift
//  ImageFeed
//
//  Created by vs on 29.02.2024.
//

import Foundation

struct UserResult: Codable {
    let profile_image: ProfileImage
    
    struct ProfileImage: Codable {
        let small: URL
        let medium: URL
        let large: URL
    }
}
