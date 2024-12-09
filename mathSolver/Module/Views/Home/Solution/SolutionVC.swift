//
//  SolutionVC.swift
//  mathSolver
//
//  Created by FFK on 29.11.2024.
//

import UIKit
import SnapKit

final class SolutionVC: BaseVC {
    
    // MARK: - Properties
    var onSolutionUpdated: ((Solution) -> Void)?
    
    private let homeVM = HomeViewModel()
    private let historyVM = HistoryViewModel()
    private var solutionModel: Solution?
    
    // MARK: - UI Components
    private lazy var customNavBar: CustomNavigationBar = {
        let navBar = CustomNavigationBar()
        navBar.configure(title: "Solution", leftAction: #selector(backButtonTapped), rightAction: #selector(rightButtonTapped), target: self, leftImage: UIImage(systemName: "chevron.left"), rightImage: UIImage(systemName: ""))
        return navBar
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
        collectionView.register(QuestionCell.self, forCellWithReuseIdentifier: QuestionCell.identifier)
        collectionView.register(SolutionCell.self, forCellWithReuseIdentifier: SolutionCell.identifier)
        collectionView.register(StepsCell.self, forCellWithReuseIdentifier: StepsCell.identifier)
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
    
    // MARK: - Public Methods
    func setupSolutionData(solution: Solution) {
        self.solutionModel = solution
        collectionView.reloadData()
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        view.backgroundColor = Constants.Colors.backgroundColor
        view.addSubview(customNavBar)
        view.addSubview(collectionView)
        
        customNavBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.Layout.navBarHeight)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(customNavBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
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
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        if let solution = solutionModel {
            let homeVC = LearnVC()
            homeVC.setupSolutionData(solution: solution)
            navigationController?.setViewControllers([homeVC], animated: true)
        }
    }
    
    @objc private func rightButtonTapped() {
        
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SolutionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuestionCell.identifier, for: indexPath) as! QuestionCell
            cell.configure(question: solutionModel?.question ?? "no data question")
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SolutionCell.identifier, for: indexPath) as! SolutionCell
            cell.configure(solution: solutionModel?.solution ?? "no data solution")
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StepsCell.identifier, for: indexPath) as! StepsCell
            cell.configure(steps: solutionModel?.steps ?? ["no data question"])
            return cell
        default:
            fatalError("Invalid section")
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension SolutionVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            homeVM.processImage(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
