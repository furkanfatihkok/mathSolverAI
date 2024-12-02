//
//  PaywallVC.swift
//  mathSolver
//
//  Created by FFK on 28.11.2024.
//

import UIKit
import SnapKit

final class PaywallVC: UIViewController {

    // MARK: - UI Components
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: Constants.Paywall.closeButtonIcon), for: .normal)
        button.tintColor = Constants.Colors.purpleColor
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()

    private lazy var crownImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: Constants.Paywall.crownImageName))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Paywall.titleText
        label.font = Constants.Fonts.poppinsBold(size: Constants.Layout.titleFontSize)
        label.textColor = Constants.Colors.purpleColor
        label.textAlignment = .center
        return label
    }()

    private lazy var bulletPointsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: createBulletPoints())
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()

    private lazy var monthlyOptionView: SubscriptionOptionView = {
        let view = SubscriptionOptionView(
            title: Constants.Paywall.monthlyTitle,
            price: Constants.Paywall.monthlyPrice,
            isSelected: false
        )
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(monthlyTapped)))
        return view
    }()

    private lazy var annualOptionView: SubscriptionOptionView = {
        let view = SubscriptionOptionView(
            title: Constants.Paywall.annualTitle,
            price: Constants.Paywall.annualPrice,
            isSelected: true
        )
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(annualTapped)))
        return view
    }()

    private lazy var startButton: UIButton = {
        let button = UIButton.onboardingButton(title: .startButton)
        button.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureStartButtonAction()
    }

    private func setupViews() {
        view.backgroundColor = Constants.Colors.backgroundColor
        view.addSubview(closeButton)
        view.addSubview(crownImageView)
        view.addSubview(titleLabel)
        view.addSubview(bulletPointsStack)
        view.addSubview(monthlyOptionView)
        view.addSubview(annualOptionView)
        view.addSubview(startButton)

        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(30)
        }

        crownImageView.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(Constants.Layout.imageWidth * 0.8)
            make.height.equalTo(Constants.Layout.imageHeight * 0.8)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(crownImageView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }

        bulletPointsStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(30)
        }

        monthlyOptionView.snp.makeConstraints { make in
            make.top.equalTo(bulletPointsStack.snp.bottom).offset(64)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(Constants.Layout.buttonHeightFixed)
        }

        annualOptionView.snp.makeConstraints { make in
            make.top.equalTo(monthlyOptionView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(Constants.Layout.buttonHeightFixed)
        }

        startButton.snp.makeConstraints { make in
            make.top.equalTo(annualOptionView.snp.bottom).offset(45)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(Constants.Layout.buttonHeightFixed)
            make.width.equalTo(Constants.Layout.buttonWidthFixed)
        }
    }

    private func createBulletPoints() -> [UILabel] {
        return Constants.Paywall.bulletPoints.map { text in
            let label = UILabel()
            label.text = "◉ \(text)"
            label.font = Constants.Fonts.poppinsRegular(size: Constants.Layout.descriptionFontSize * 0.8 )
            label.textColor = .black
            label.textAlignment = .center
            return label
        }
    }

    private func configureStartButtonAction() {
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
    }

    // MARK: - Actions
    @objc private func closeTapped() {
        let homeVC = EmptyVC()
        let navigationController = UINavigationController(rootViewController: homeVC)
        navigationController.modalPresentationStyle = .fullScreen

        if let window = UIApplication.shared.windows.first {
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }

    @objc private func monthlyTapped() {
        monthlyOptionView.setSelected(true)
        annualOptionView.setSelected(false)
    }

    @objc private func annualTapped() {
        monthlyOptionView.setSelected(false)
        annualOptionView.setSelected(true)
    }

    @objc private func startTapped() {
        print("Start subscription tapped")
    }
}
