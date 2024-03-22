//
//  ProfileViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by vs on 19.03.2024.
//

import ImageFeed
import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    
    var viewDidLoadCalled: Bool = false
    var didLogout: Bool = false
    var view: ProfileViewControllerProtocol?
    
    init(view: ProfileViewControllerProtocol? = nil) {
        self.view = view
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
        let profile = Profile(username: "user",
                              name: "name",
                              loginName: "loginName",
                              bio: "bio")
        let url = URL(string: "https://avatar.com")
        view?.updateProfileDetails(profile, url)
    }
    
    func logout() {
        didLogout = true
    }
    
}
