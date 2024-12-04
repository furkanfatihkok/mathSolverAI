//
//  SolutionVC.swift
//  mathSolver
//
//  Created by FFK on 29.11.2024.
//

import UIKit
import SnapKit

#warning("Navbar ekle")

final class SolutionVC: UIViewController {
    private let homeVM = HomeViewModel()
    private let historyVM = HistoryViewModel()
    private var solutionModel: Solution?
    
    // MARK: - UI Components
    private lazy var customNavBar: CustomNavigationBar = {
        let navBar = CustomNavigationBar()
        navBar.configure(title: "Solution", backAction: #selector(backButtonTapped), target: self)
        return navBar
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.HomePage.EmptyVC.title
        label.font = Constants.Fonts.poppinsBold(size: Constants.Layout.titleFontSize)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var historyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("History", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(Constants.Colors.purpleColor, for: .normal)
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
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: DateCell.identifier)
        collectionView.register(QuestionCell.self, forCellWithReuseIdentifier: QuestionCell.identifier)
        collectionView.register(SolutionCell.self, forCellWithReuseIdentifier: SolutionCell.identifier)
        collectionView.register(StepsCell.self, forCellWithReuseIdentifier: StepsCell.identifier)
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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
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
        view.addSubview(titleLabel)
        view.addSubview(historyButton)
        view.addSubview(collectionView)
        view.addSubview(circleButton)
        view.addSubview(activityIndicator)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
        
        historyButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
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
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        view.bringSubviewToFront(circleButton)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 140, right: 0)
        collectionView.scrollIndicatorInsets = collectionView.contentInset
    }
    
    private func bindViewModel() {
        homeVM.solvedResult = { [weak self] question, solution in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                
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
                self?.activityIndicator.stopAnimating()
                AlertManager.shared.showAlert(on: self!, title: "Error", message: error)
            }
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func historyButtonTapped() {
        guard let solutionModel = solutionModel else { return }
        
        historyVM.saveSolution(solutionModel) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    let historyVC = HistoryVC()
                    self?.navigationController?.pushViewController(historyVC, animated: true)
                case .failure(let error):
                    print("Error saving solution: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @objc private func circleButtonTapped() {
        CircleButtonManager.shared.presentActionSheet(on: self) { [weak self] selectedImage in
            guard let self = self, let image = selectedImage else { return }
            self.activityIndicator.startAnimating()
            self.homeVM.processImage(image: image)
        }
    }
}

extension SolutionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCell.identifier, for: indexPath) as! DateCell
            cell.configureDate()
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuestionCell.identifier, for: indexPath) as! QuestionCell
            cell.configure(question: solutionModel?.question ?? "no data question")
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SolutionCell.identifier, for: indexPath) as! SolutionCell
            cell.configure(solution: solutionModel?.solution ?? "no data solution")
            return cell
        case 3:
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
            activityIndicator.startAnimating()
            homeVM.processImage(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
