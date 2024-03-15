//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by vs on 19.01.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private var avatarImageView: UIImageView!
    private var nameLabel: UILabel!
    private var loginNameLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var logoutButton: UIButton!
    
    private let profileService: ProfileService = ProfileService.shared
    private let profileImageService: ProfileImageService = ProfileImageService.shared
    private let profileLogoutService: ProfileLogoutService = ProfileLogoutService.shared
    
    private var safeArea: UILayoutGuide { view.safeAreaLayoutGuide }
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepare()
        updateProfileDetails()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] in
                guard let self else {
                    return
                }
                self.updateAvatar($0)
            }
    }
    
}

// MARK: - Actions
extension ProfileViewController {
    
    @objc private func logoutAction() {
        let alert = UIAlertController(title: "Пока, пока!",
                                      message: "Уверены, что хотите выйти?",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self else { return }
            self.profileLogoutService.logout()
        }
        let cancelAction = UIAlertAction(title: "Нет", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - Helpers
extension ProfileViewController {
    
    private func prepare() {
        initAvatarImageView()
        initNameLabel()
        initLoginNameLabel()
        initDescriptionLabel()
        initLogoutButton()
        
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(loginNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 17),
            avatarImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: logoutButton.trailingAnchor),
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            loginNameLabel.trailingAnchor.constraint(equalTo: logoutButton.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: logoutButton.trailingAnchor),
            logoutButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30),
            logoutButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
        ])
    }
    
    private func initAvatarImageView() {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame = .init(x: 16, y: 32, width: 70, height: 70)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 35
        imageView.image = UIImage(named: "mock_avatar")
        avatarImageView = imageView
    }
    
    private func initNameLabel() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.frame = .init(x: 0, y: 8, width: 0, height: 0)
        label.textColor = .white
        label.font = .systemFont(ofSize: 23, weight: .semibold)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.text = "Екатерина Новикова"
        nameLabel = label
    }
    
    private func initLoginNameLabel() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.frame = .init(x: 0, y: 8, width: 0, height: 0)
        label.textColor = UIColor(hex: "#AEAFB4")
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.text = "@ekaterina_nov"
        loginNameLabel = label
    }
    
    private func initDescriptionLabel() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.frame = .init(x: 0, y: 8, width: 0, height: 0)
        label.textColor = .white
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.text = "Hello, World!"
        descriptionLabel = label
    }
    
    private func initLogoutButton() {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "logout_button"), for: .normal)
        btn.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
        logoutButton = btn
    }
    
    private func updateProfileDetails() {
        let profile = profileService.profile
        let url = URL(string: profileImageService.avatarURL ?? "")
        nameLabel.text = profile?.name
        loginNameLabel.text = profile?.loginName
        descriptionLabel.text = profile?.bio
        updateAvatar(url: url)
    }
    
    private func updateAvatar(_ notification: Notification) {
        let url = URL(string: profileImageService.avatarURL ?? "")
        updateAvatar(url: url)
    }
    
    private func updateAvatar(url: URL?) {
        guard let url else {
            return
        }
        let options: KingfisherOptionsInfo = [.scaleFactor(UIScreen.main.scale),
                                              .cacheOriginalImage]
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(with: url, options: options)
    }
    
}
