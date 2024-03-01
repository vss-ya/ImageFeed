//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by vs on 08.02.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private let authSegueIdentifier = "Auth"
    private let tabBarStoryboardID = "TabBarViewController"

    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let splashScreenLogo = splashScreenLogo()
        NSLayoutConstraint.activate([
            splashScreenLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashScreenLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        if let token = oauth2TokenStorage.token {
            didAuthenticate(token)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            guard let vc = storyboard.instantiateViewController(
                withIdentifier: "AuthViewController"
            ) as? AuthViewController else
            {
                assertionFailure("Invalid Configuration")
                return
            }
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
}

extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }

    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.didAuthenticate(token)
            case .failure:
                DispatchQueue.main.async {
                    self.showAuthFailed()
                    UIBlockingProgressHUD.dismiss()
                }
            }
        }
    }
    
}

extension SplashViewController {
    
    private func splashScreenLogo() -> UIImageView {
        let splashScreenLogo = UIImageView(image: UIImage(named: "Logo_of_Unsplash"))
        view.addSubview(splashScreenLogo)
        splashScreenLogo.translatesAutoresizingMaskIntoConstraints = false
        
        return splashScreenLogo
    }
    
    private func showAuthFailed() {
        let model = AlertModel(title: "Что-то пошло не так",
                               message: "Не удалось войти в систему",
                               buttonText: "Ок")
        AlertPresenter.show(model, self) {}
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: tabBarStoryboardID)
        window.rootViewController = tabBarController
    }
    
    private func didAuthenticate(_ token: String) {
        oauth2TokenStorage.token = token
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else {
                return
            }
            
            defer {
                DispatchQueue.main.async {
                    UIBlockingProgressHUD.dismiss()
                    self.switchToTabBarController()
                }
            }
            
            switch result {
            case .success(let profile):
                self.profileImageService.fetchProfileImageURL(profile.username) { _ in }
            case .failure:
                break
            }
        }
    }
    
}
