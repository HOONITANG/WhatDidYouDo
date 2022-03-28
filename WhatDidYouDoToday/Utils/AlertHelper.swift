//
//  AlertHelper.swift
//  WhatDidYouDoToday
//
//  Created by Taehoon Kim on 2022/02/14.
//

import UIKit

enum AlertType {
    case delete
    case basic
}

class AlertHelper {
    static func showAlert(title: String?, message: String?, type: AlertType = .basic, over viewController: UIViewController, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: I18NStrings.Alert.ok, style: .default, handler: handler))
        if type == .delete {
            alert.addAction(UIAlertAction(title: I18NStrings.Alert.cancel, style: .cancel, handler: nil))
        }
        
        viewController.present(alert, animated: true)
    }
}
