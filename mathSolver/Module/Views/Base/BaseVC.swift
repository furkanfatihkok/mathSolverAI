//
//  BaseVC.swift
//  mathSolver
//
//  Created by FFK on 9.12.2024.
//

import UIKit
import NeonSDK

class BaseVC: UIViewController {
    
    private lazy var loadingAnimationView: NeonAnimationView = {
        let animationView = NeonAnimationView(animation: .custom(name: "infinity"))
        animationView.lottieAnimationView.loopMode = .loop
        animationView.isHidden = true
        return animationView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingAnimation()
    }
    
    private func setupLoadingAnimation() {
        view.addSubview(loadingAnimationView)
        loadingAnimationView.layer.zPosition = 1
        loadingAnimationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
    }
    
    func showLoadingAnimation() {
        loadingAnimationView.isHidden = false
        loadingAnimationView.lottieAnimationView.play()
    }

    func hideLoadingAnimation() {
        loadingAnimationView.lottieAnimationView.stop()
        loadingAnimationView.isHidden = true
    }
}
