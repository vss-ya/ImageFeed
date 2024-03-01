//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by vs on 29.02.2024.
//

import UIKit

final class AlertPresenter {
    
    static func show(_ model: AlertModel, _ vc: UIViewController, completion: @escaping (() -> Void)) {
        let ac = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            completion()
        }
        ac.addAction(action)
        ac.view.accessibilityIdentifier = model.accessibilityIdentifier
        vc.present(ac, animated: true, completion: nil)
    }
    
}
