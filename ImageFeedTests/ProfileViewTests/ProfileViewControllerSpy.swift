//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by vs on 19.03.2024.
//

import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    
    var presenter: ImageFeed.ProfileViewPresenterProtocol?
    
    private(set) var profile: Profile?
    private(set) var avatarUrl: URL?
    
    func updateProfileDetails(_ profile: ImageFeed.Profile?, _ avatarUrl: URL?) {
        self.profile = profile
        updateAvatar(avatarUrl)
    }
    
    func updateAvatar(_ url: URL?) {
        self.avatarUrl = url
    }
    
    func logout() {
        presenter?.logout()
    }
    
}
