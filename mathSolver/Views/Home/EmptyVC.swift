//
//  EmptyVC.swift
//  mathSolver
//
//  Created by FFK on 20.11.2024.
//

import UIKit

final class EmptyVC: UIViewController {
    private let viewModel = HomeViewModel()
    
    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.HomePage.EmptyVC.title
        label.font = Constants.Fonts.poppinsBold(size: Constants.Layout.titleFontSize)
        label.textColor = .black
        label.textAlignment = .center
        return label
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
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: Constants.HomePage.EmptyVC.settingsIcon)?.withTintColor(Constants.Colors.purpleColor, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Setup Methods
    private func setupViews() {
        view.backgroundColor = .white
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
            make.top.equalTo(titleLabel.snp.bottom).offset(237)
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
            make.top.equalTo(arrowImageView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
    }
    
    private func setupBindings() {
        viewModel.solvedResult = { [weak self] question, solution in
            DispatchQueue.main.async {
                let stepsFromAPI = ["Step 1: \(question)", "Step 2: Analyze solution", "Step 3: \(solution)"]
                self?.navigateToSolutionScreen(question: question, solution: solution, steps: stepsFromAPI)
            }
        }
        
        viewModel.showError = { [weak self] error in
            DispatchQueue.main.async {
                AlertManager.shared.showAlert(on: self!, title: "Error", message: error)
            }
        }
    }
    
    // MARK: - Actions
    @objc private func circleButtonTapped() {
        CircleButtonManager.shared.presentActionSheet(on: self) { [weak self] selectedImage in
            guard let image = selectedImage else { return }
            self?.viewModel.processImage(image: image)
        }
    }
    
    @objc private func settingsButtonTapped() {
        let settingsVC = SettingsVC()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    private func navigateToSolutionScreen(question: String, solution: String, steps: [String]) {
        let solutionVC = SolutionVC()
        solutionVC.setupSolutionData(question: question, solution: solution, steps: steps)
        navigationController?.pushViewController(solutionVC, animated: true)
    }
}

// MARK: - ImagePicker & NavigationController Delegate
extension EmptyVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            viewModel.processImage(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
