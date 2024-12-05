//
//  SceneDelegate.swift
//  mathSolver
//
//  Created by FFK on 20.11.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let isOnboardingCompleted = UserDefaults.standard.bool(forKey: "isOnboardingCompleted")
        
        if isOnboardingCompleted {
            checkForData { latestSolution in
                DispatchQueue.main.async {
                    let rootVC: UIViewController
                    if let solution = latestSolution {
                        let learnVC = LearnVC()
                        learnVC.setupSolutionData(solution: solution)
                        rootVC = learnVC
                    } else {
                        rootVC = EmptyVC()
                    }
                    
                    let navigationController = UINavigationController(rootViewController: rootVC)
                    window.rootViewController = navigationController
                    window.makeKeyAndVisible()
                }
            }
        } else {
            let onboardingVC = WelcomePageVC()
            let navigationController = UINavigationController(rootViewController: onboardingVC)
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }
    
    private func checkForData(completion: @escaping (Solution?) -> Void) {
        let viewModel = HistoryViewModel()
        
        viewModel.fetchHistory { result in
            switch result {
            case .success:
                completion(viewModel.getLastestSolution())
            case .failure:
                completion(nil)
            }
        }
    }
}
