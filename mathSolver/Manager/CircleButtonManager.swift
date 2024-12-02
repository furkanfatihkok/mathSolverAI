//
//  CircleButtonManager.swift
//  mathSolver
//
//  Created by FFK on 2.12.2024.
//

import UIKit

final class CircleButtonManager {
    static let shared = CircleButtonManager()
    private init() {}
    
    func presentActionSheet(on viewController: UIViewController, completion: @escaping (UIImage?) -> Void) {
        let cameraAction = UIAlertAction(title: "Take a picture", style: .default) { _ in
            self.openCamera(on: viewController, completion: completion)
        }
        
        let galleryAction = UIAlertAction(title: "Upload from photos", style: .default) { _ in
            self.openPhotoLibrary(on: viewController, completion: completion)
        }
        
        AlertManager.shared.showActionSheet(
            on: viewController,
            title: "Add math problem",
            message: nil,
            actions: [cameraAction, galleryAction]
        )
    }
    
    private func openCamera(on viewController: UIViewController, completion: @escaping (UIImage?) -> Void) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            AlertManager.shared.showAlert(on: viewController, title: "Error", message: "Camera is not available.")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = viewController as? (UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        imagePicker.allowsEditing = false
        viewController.present(imagePicker, animated: true, completion: nil)
    }
    
    private func openPhotoLibrary(on viewController: UIViewController, completion: @escaping (UIImage?) -> Void) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            AlertManager.shared.showAlert(on: viewController, title: "Error", message: "Photo Library is not available.")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = viewController as? (UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        viewController.present(imagePicker, animated: true, completion: nil)
    }
}

