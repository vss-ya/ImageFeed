//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by vs on 07.02.2024.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
    
}

final class AuthViewController: UIViewController {

    private let WebSegueIdentifier = "Web"
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == WebSegueIdentifier {
            let vc = segue.destination as! WebViewController
            vc.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
}

extension AuthViewController: WebViewControllerDelegate {
    
    func webViewController(_ vc: WebViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }

    func webViewControllerDidCancel(_ vc: WebViewController) {
        dismiss(animated: true)
    }
    
}

