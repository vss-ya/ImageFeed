//
//  Profile.swift
//  ImageFeed
//
//  Created by vs on 26.02.2024.
//

import Foundation

public struct Profile {
    public let username: String
    public let name: String
    public let loginName: String
    public let bio: String
    
    public init(username: String, name: String, loginName: String, bio: String) {
        self.username = username
        self.name = name
        self.loginName = loginName
        self.bio = bio
    }
}
