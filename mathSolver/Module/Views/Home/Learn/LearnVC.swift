//
//  LearnVC.swift
//  mathSolver
//
//  Created by FFK on 29.11.2024.
//

import UIKit
import NeonSDK

final class LearnVC: BaseVC {
    
    // MARK: - Properties
    private let homeVM = HomeViewModel()
    private let historyVM = HistoryViewModel()
    private var solutionModel: Solution?

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

    private lazy var historyButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "tray.full")?.withTintColor(Constants.Colors.purpleColor, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(historyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(white: 0.97, alpha: 1)
        collectionView.register(LearnDateCell.self, forCellWithReuseIdentifier: LearnDateCell.identifier)
        collectionView.register(LearnQuestionCell.self, forCellWithReuseIdentifier: LearnQuestionCell.identifier)
        collectionView.register(LearnSolutionCell.self, forCellWithReuseIdentifier: LearnSolutionCell.identifier)
        collectionView.register(LearnStepsCell.self, forCellWithReuseIdentifier: LearnStepsCell.identifier)
        return collectionView
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
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Public Methods
    func setupSolutionData(solution: Solution) {
        self.solutionModel = solution
        collectionView.reloadData()
        saveToHistory(solution)
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        view.backgroundColor = Constants.Colors.backgroundColor
        view.addSubview(titleLabel)
        view.addSubview(settingsButton)
        view.addSubview(historyButton)
        view.addSubview(collectionView)
        view.addSubview(circleButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
        
        settingsButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
        
        historyButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        circleButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            make.width.height.equalTo(100)
        }
    }
    
    private func bindViewModel() {
        homeVM.solvedResult = { [weak self] question, solution in
            DispatchQueue.main.async {
                self?.hideLoadingAnimation()
                
                let solutionModel = Solution(
                    question: question,
                    solution: solution,
                    steps: [
                        "Step 1: \(question)",
                        "Step 2: Analyze the problem",
                        "Step 3: \(solution)"
                    ]
                )
                self?.setupSolutionData(solution: solutionModel)
            }
        }
        
        homeVM.showError = { [weak self] error in
            DispatchQueue.main.async {
                self?.hideLoadingAnimation()
                AlertManager.shared.showAlert(on: self!, title: "Error", message: error)
            }
        }
    }
    
    private func saveToHistory(_ solution: Solution) {
        historyVM.saveSolution(solution) { result in
            switch result {
            case .success:
                print("Solution saved to history.")
            case .failure(let error):
                print("Error saving to history: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Actions
    @objc private func settingsButtonTapped() {
        let settingsVC = SettingsVC()
        navigationController?.pushViewController(settingsVC, animated: true)
    }

    @objc private func historyButtonTapped() {
        let historyVC = HistoryVC()
        navigationController?.pushViewController(historyVC, animated: true)
    }
    
    @objc private func circleButtonTapped() {
        CircleButtonManager.shared.presentActionSheet(on: self) { [weak self] selectedImage in
            guard let self = self, let image = selectedImage else { return }
            self.showLoadingAnimation()
            self.homeVM.processImage(image: image)
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension LearnVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LearnDateCell.identifier, for: indexPath) as! LearnDateCell
            cell.configureDate()
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LearnQuestionCell.identifier, for: indexPath) as! LearnQuestionCell
            cell.configure(question: solutionModel?.question ?? "no data question")
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LearnSolutionCell.identifier, for: indexPath) as! LearnSolutionCell
            cell.configure(solution: solutionModel?.solution ?? "no data solution")
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LearnStepsCell.identifier, for: indexPath) as! LearnStepsCell
            cell.configure(steps: solutionModel?.steps ?? ["no data question"])
            return cell
        default:
            fatalError("Invalid section")
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension LearnVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            showLoadingAnimation()
            homeVM.processImage(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
