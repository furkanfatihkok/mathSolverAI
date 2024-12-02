//
//  SettingsOption.swift
//  mathSolver
//
//  Created by FFK on 27.11.2024.
//

import UIKit

enum SettingsOption: CaseIterable {
    case shareApp
    case rateUs
    case contactUs
    case termsOfService
    case privacyPolicy

    var title: String {
        switch self {
        case .shareApp: return "Share app"
        case .rateUs: return "Rate us"
        case .contactUs: return "Contact us"
        case .termsOfService: return "Terms of service"
        case .privacyPolicy: return "Privacy policy"
        }
    }

    var icon: UIImage? {
        switch self {
        case .shareApp: return UIImage(systemName: "square.and.arrow.up")
        case .rateUs: return UIImage(systemName: "star")
        case .contactUs: return UIImage(systemName: "envelope")
        case .termsOfService: return UIImage(systemName: "info.circle")
        case .privacyPolicy: return UIImage(systemName: "eye")
        }
    }
}
