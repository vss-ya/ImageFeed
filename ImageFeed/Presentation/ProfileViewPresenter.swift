//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by vs on 19.03.2024.
//

import Foundation

public protocol ProfileViewPresenterProtocol {
    
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func logout()
    
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    
    private let profileService: ProfileService = ProfileService.shared
    private let profileImageService: ProfileImageService = ProfileImageService.shared
    private let profileLogoutService: ProfileLogoutService = ProfileLogoutService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    init(view: ProfileViewControllerProtocol? = nil) {
        self.view = view
    }
    
    func viewDidLoad() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self](_) in
                guard let self else {
                    return
                }
                let url = URL(string: profileImageService.avatarURL ?? "")
                view?.updateAvatar(url)
            }
        let profile = profileService.profile
        let url = URL(string: profileImageService.avatarURL ?? "")
        view?.updateProfileDetails(profile, url)
    }
    
    func logout() {
        profileLogoutService.logout()
    }
    
}
