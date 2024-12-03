//
//  WelcomePageVC.swift
//  mathSolver
//
//  Created by FFK on 26.11.2024.
//

import UIKit
import SnapKit

final class WelcomePageVC: UIViewController {
    
    // MARK: - Properties
    private var currentSymbolIndex = 0

    // MARK: - UI Components
    private lazy var animatedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.WelcomePage.animatedButtonSymbols[currentSymbolIndex], for: .normal)
        button.titleLabel?.font = Constants.Fonts.poppinsBold(size: Constants.Layout.titleFontSize * 1.5)
        button.setTitleColor(Constants.Colors.purpleColor, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = Constants.Layout.imageWidth / 2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        return button
    }()

    private lazy var ellipsisImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ellipsis")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.WelcomePage.title
        label.font = Constants.Fonts.poppinsBold(size: Constants.Layout.titleFontSize * 0.85)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var continueButton: UIButton = {
        let button = UIButton.onboardingButton(title: .continueButton)
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        startAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Setup Methods
    private func setupViews() {
        view.backgroundColor = Constants.Colors.backgroundColor
        view.addSubview(animatedButton)
        view.addSubview(ellipsisImageView)
        view.addSubview(titleLabel)
        view.addSubview(continueButton)

        animatedButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(190)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(Constants.Layout.imageWidth)
        }

        ellipsisImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(400)
            make.height.equalTo(580)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(ellipsisImageView.snp.bottom).offset(-10)
            make.left.right.equalToSuperview().inset(20)
        }

        continueButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-15)
            make.centerX.equalToSuperview()
            make.height.equalTo(Constants.Layout.buttonHeightFixed)
            make.width.equalTo(Constants.Layout.buttonWidthFixed)
        }
    }

    // MARK: - Animation Methods
    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.animateSymbolChange()
        }
    }

    private func animateSymbolChange() {
        currentSymbolIndex = (currentSymbolIndex + 1) % Constants.WelcomePage.animatedButtonSymbols.count
        animatedButton.setTitle(Constants.WelcomePage.animatedButtonSymbols[currentSymbolIndex], for: .normal)
    }

    // MARK: - Actions
    @objc private func continueButtonTapped() {
        let onboardingVC = OnboardingVC()
        navigationController?.pushViewController(onboardingVC, animated: true)
    }
}
