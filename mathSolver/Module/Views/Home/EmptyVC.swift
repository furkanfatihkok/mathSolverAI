//
//  EmptyVC.swift
//  mathSolver
//
//  Created by FFK on 20.11.2024.
//

import UIKit

final class EmptyVC: BaseVC {
    
    // MARK: - Properties
    private let homeVM = HomeViewModel()
    
    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.HomePage.EmptyVC.title
        label.font = Constants.Fonts.poppinsBold(size: Constants.Layout.titleFontSize)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: Constants.HomePage.EmptyVC.settingsIcon)?.withTintColor(Constants.Colors.purpleColor, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var startLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.HomePage.EmptyVC.startLabel
        label.font = Constants.Fonts.poppinsBold(size: Constants.Layout.titleFontSize * 0.9)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.HomePage.EmptyVC.descriptionText
        label.font = Constants.Fonts.poppinsRegular(size: Constants.Layout.descriptionFontSize)
        label.textColor = Constants.Colors.darkGrayColor
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arrow")
        return imageView
    }()
    
    private lazy var circleButton: UIButton = {
        UIButton.createCircleButton(
            backgroundColor: Constants.Colors.purpleColor,
            size: 100,
            action: #selector(circleButtonTapped),
            target: self
        )
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Setup Methods
    private func setupViews() {
        view.backgroundColor = Constants.Colors.backgroundColor
        view.addSubview(titleLabel)
        view.addSubview(settingsButton)
        view.addSubview(startLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(arrowImageView)
        view.addSubview(circleButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
        
        settingsButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(30)
        }
        
        startLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(160)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(startLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(30)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(150)
        }
        
        circleButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            make.width.height.equalTo(100)
        }
    }
    
    private func navigateToSolutionScreen(question: String, solution: String, steps: [String]) {
        let solutionModel = Solution(question: question, solution: solution, steps: steps)
        let solutionVC = SolutionVC()
        solutionVC.setupSolutionData(solution: solutionModel)
        navigationController?.pushViewController(solutionVC, animated: true)
    }
    
    private func bindViewModel() {
        homeVM.solvedResult = { [weak self] question, solution in
            DispatchQueue.main.async {
                self?.hideLoadingAnimation()
                let stepsFromAPI = ["Step 1: \(question)", "Step 2: Analyze solution", "Step 3: \(solution)"]
                self?.navigateToSolutionScreen(question: question, solution: solution, steps: stepsFromAPI)
            }
        }
        
        homeVM.showError = { [weak self] error in
            DispatchQueue.main.async {
                self?.hideLoadingAnimation()
                AlertManager.shared.showAlert(on: self!, title: "Error", message: error)
            }
        }
    }
    
    // MARK: - Actions
    @objc private func circleButtonTapped() {
        CircleButtonManager.shared.presentActionSheet(on: self) { [weak self] selectedImage in
            guard let image = selectedImage else { return }
            self?.showLoadingAnimation()
            self?.homeVM.processImage(image: image)
        }
    }
    
    @objc private func settingsButtonTapped() {
        let settingsVC = SettingsVC()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
}

// MARK: - ImagePicker & NavigationController Delegate
extension EmptyVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            showLoadingAnimation()
            homeVM.processImage(image: editedImage)
        } else if let originalImage = info[.originalImage] as? UIImage {
            showLoadingAnimation()
            homeVM.processImage(image: originalImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
