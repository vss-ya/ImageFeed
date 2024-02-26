//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by vs on 29.02.2024.
//

import UIKit

class AlertPresenter {

    weak var viewController: UIViewController?

    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }

    func show(_ model: AlertModel, completion: @escaping (() -> Void)) {
        let ac = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            completion()
        }
        ac.addAction(action)
        ac.view.accessibilityIdentifier = model.accessibilityIdentifier
        viewController?.present(ac, animated: true, completion: nil)
    }
    
}
