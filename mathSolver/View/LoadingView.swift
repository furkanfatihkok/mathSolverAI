////
////  LoadingView.swift
////  mathSolver
////
////  Created by FFK on 9.12.2024.
////
//
//import UIKit
//import NeonSDK
//
//final class LoadingView: UIView {
//    
//    private lazy var animationView: NeonAnimationView = {
//        let animation = NeonAnimationView(animation: .custom(name: "math"))
//        animation.lottieAnimationView.loopMode = .loop
//        return animation
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupView()
//    }
//    
//    private func setupView() {
//        // Yarı saydam arka plan
//        addSubview(animationView)
//        
//        animationView.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.width.height.equalTo(150) // Animasyon boyutları
//        }
//    }
//    
//    func show(on parentView: UIView) {
//        isHidden = false
//        animationView.lottieAnimationView.play()
//    }
//    
//    func hide() {
//        animationView.lottieAnimationView.stop()
//        isHidden = true
//    }
//}
