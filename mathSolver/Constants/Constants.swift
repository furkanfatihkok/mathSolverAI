//
// Constants.swift
// mathSolver
//
// Created by FFK on 27.11.2024.

import UIKit

struct Constants {
    struct WelcomePage {
        static let title = "Welcome to Math Solver"
        static let animatedButtonSymbols = ["+", "x", "-", "="]
        static let continueButtonTitle = "Continue"
    }
    
    struct OnboardingPage {
        static let captureTitle = "Capture"
        static let captureDescription = "Snap a photo of your math question."
        
        static let solveTitle = "Solve"
        static let solveDescription = "Our algorithm will solve it step-by-step."
        
        static let learnTitle = "Learn"
        static let learnDescription = "Understand the problem-solving process."
        
        static let identifier = "OnboardingVC"
    }
    
    struct Paywall {
        static let closeButtonIcon = "xmark"
        static let crownImageName = "crown"
        static let titleText = "Get Premium!"
        static let bulletPoints = [
            "Lorem Ipsum Dolor Sit",
            "Lorem Ipsum Dolor Sit",
            "Lorem Ipsum Dolor Sit"
        ]
        static let monthlyTitle = "Monthly"
        static let monthlyPrice = "$15"
        static let annualTitle = "Annual"
        static let annualPrice = "$30"
        static let startButtonTitle = "Start"
    }
    
    struct HomePage {
        struct EmptyVC {
            static let title = "Math Solver"
            static let startLabel = "Start here"
            static let descriptionText = "Take a picture of your math problem or upload it from your photos."
            static let settingsIcon = "gearshape.fill"
            
            static let actionSheetTitle = "Add math problem"
            static let takePicture = "Take a picture"
            static let uploadFromPhotos = "Upload from photos"
            static let cancel = "Cancel"
        }
        struct SolutionVC {
            static let QuestionTitle = "Question"
            static let SolutionTitle = "Solution"
            static let StepsTitle = "Solving Steps"
            
        }
    }
    
    struct SettingsPage {
        static let  title = "Settings"
    }
    
    struct Cells {
        struct OnboardingCell {
            static let identifier = "OnboardingCell"
        }
        
        struct HomeDateCell {
            static let identifier = "HomeDateCell"
        }
        
        struct HomeQuestionCell {
            static let identifier = "HomeQuestionCell"
        }
        
        struct HomeSolutionCell {
            static let identifier = "HomeSolutionCell"
        }
        
        struct HomeStepsCell {
            static let identifier = "HomeStepsCell"
        }
        
        struct DateCell {
            static let identifier = "DateCell"
        }
        
        struct QuestionCell {
            static let identifier = "QuestionCell"
        }
        
        struct SolutionCell {
            static let identifier = "SolutionCell"
        }
        
        struct StepsCell {
            static let identifier = "StepsCell"
        }
        
        struct HistoryHeaderView {
            static let identifier = "HistoryHeaderView"
        }
        
        struct HistoryCell {
            static let identifier = "HistoryCell"
        }
    }
    
    struct Fonts {
        static func poppinsRegular(size: CGFloat) -> UIFont? {
            return UIFont(name: "Poppins-Regular", size: size)
        }
        
        static func poppinsBold(size: CGFloat) -> UIFont? {
            return UIFont(name: "Poppins-Bold", size: size)
        }
    }
    
    struct Colors {
        static let purpleColor = UIColor(red: 129/255, green: 81/255, blue: 223/255, alpha: 1.0)
        static let darkGrayColor = UIColor.darkGray
        static let navBarColor = UIColor(red: 245/255, green: 247/255, blue: 252/255, alpha: 1.0)
        static let backgroundColor = UIColor(red: 250/255, green: 248/255, blue: 255/255, alpha: 1.0)
    }
    
    struct Layout {
        static var buttonHeightFixed: CGFloat {
            return UIScreen.main.bounds.height * 0.08
        }
        
        static var buttonWidthFixed: CGFloat {
            return UIScreen.main.bounds.width * 0.9
        }
        
        static var navBarHeight: CGFloat {
            return UIDevice.current.userInterfaceIdiom == .pad ? 80 : 60
        }
        
        static let buttonCornerRadius: CGFloat = UIScreen.main.bounds.height * 0.04
        static let titleFontSize: CGFloat = UIScreen.main.bounds.height * 0.04
        static let descriptionFontSize: CGFloat = UIScreen.main.bounds.height * 0.025
        static let imageWidth: CGFloat = UIScreen.main.bounds.width * 0.5
        static let imageHeight: CGFloat = UIScreen.main.bounds.height * 0.25
    }
}
