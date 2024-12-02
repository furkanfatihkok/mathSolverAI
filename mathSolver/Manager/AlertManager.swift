//
//  AlertManager.swift
//  mathSolver
//
//  Created by FFK on 2.12.2024.
//

import UIKit

final class AlertManager {
    static let shared = AlertManager()
    private init() {}
    
    func showAlert(on viewController: UIViewController, title: String, message: String, actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default, handler: nil)]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func showActionSheet(on viewController: UIViewController, title: String?, message: String?, actions: [UIAlertAction], cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        actions.forEach { actionSheet.addAction($0) }
        actionSheet.addAction(cancelAction)
        viewController.present(actionSheet, animated: true, completion: nil)
    }
}

