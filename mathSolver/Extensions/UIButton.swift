//
//  UIButton.swift
//  mathSolver
//
//  Created by FFK on 20.11.2024.
//

import UIKit

enum ButtonTitle: String {
    case continueButton = "Continue"
    case startButton = "Start"
}

extension UIButton {
    static func onboardingButton(title: ButtonTitle) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title.rawValue, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.Colors.purpleColor
        button.titleLabel?.font = Constants.Fonts.poppinsBold(size: 24)
        button.layer.cornerRadius = Constants.Layout.buttonCornerRadius
        return button
    }
    
    static func createCircleButton(backgroundColor: UIColor, size: CGFloat, shadowColor: UIColor = .black, shadowOpacity: Float = 0.2, shadowOffset: CGSize = CGSize(width: 0, height: 4), shadowRadius: CGFloat = 8, action: Selector, target: Any) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = size / 2
        button.layer.shadowColor = shadowColor.cgColor
        button.layer.shadowOpacity = shadowOpacity
        button.layer.shadowOffset = shadowOffset
        button.layer.shadowRadius = shadowRadius
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
}
