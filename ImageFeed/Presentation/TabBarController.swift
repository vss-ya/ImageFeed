//
//  TabBarController.swift
//  ImageFeed
//
//  Created by vs on 29.02.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imagesListVc = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )
        let profileVc = ProfileViewController()
        profileVc.presenter = ProfileViewPresenter(view: profileVc)
        profileVc.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        profileVc.tabBarItem.accessibilityIdentifier = "Profile"
        viewControllers = [imagesListVc, profileVc]
    }
    
}
