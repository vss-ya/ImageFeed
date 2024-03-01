//
//  UserResult.swift
//  ImageFeed
//
//  Created by vs on 29.02.2024.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
    
    struct ProfileImage: Codable {
        let small: URL
        let medium: URL
        let large: URL
        
        enum CodingKeys: String, CodingKey {
            case small
            case medium
            case large
        }
    }
}
