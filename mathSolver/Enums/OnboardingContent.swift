//
//  OnboardingContent.swift
//  mathSolver
//
//  Created by FFK on 26.11.2024.
//

import UIKit

enum OnboardingContent: CaseIterable {
    case capture
    case solve
    case learn

    var title: String {
        switch self {
        case .capture:
            return Constants.OnboardingPage.captureTitle
        case .solve:
            return Constants.OnboardingPage.solveTitle
        case .learn:
            return Constants.OnboardingPage.learnTitle
        }
    }

    var description: String {
        switch self {
        case .capture:
            return Constants.OnboardingPage.captureDescription
        case .solve:
            return Constants.OnboardingPage.solveDescription
        case .learn:
            return Constants.OnboardingPage.learnDescription
        }
    }

    var image: UIImage {
        switch self {
        case .capture:
            return UIImage(named: "capture") ?? UIImage()
        case .solve:
            return UIImage(named: "solve") ?? UIImage()
        case .learn:
            return UIImage(named: "learn") ?? UIImage()
        }
    }
}
