//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by vs on 26.02.2024.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let first_name: String
    let last_name: String?
    let bio: String?
}
