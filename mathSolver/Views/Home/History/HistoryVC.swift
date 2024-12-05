//
//  HistoryVC.swift
//  mathSolver
//
//  Created by FFK on 3.12.2024.
//

import UIKit

final class HistoryVC: UIViewController {
    
    // MARK: - Properties
    private var historyData: [String: [[String: Any]]] = [:]
    private let viewModel = HistoryViewModel()
    private var isDeleteMode: Bool = false
    
    // MARK: - UI Components
    private lazy var customNavBar: CustomNavigationBar = {
        let navBar = CustomNavigationBar()
        navBar.configure(title: "History", leftAction: #selector(backButtonTapped), rightAction: #selector(rightButtonTapped), target: self, leftImage: UIImage(systemName: "chevron.left"), rightImage: UIImage(systemName: "ellipsis"))
        navBar.rightButton.menu = createMenu()
        navBar.rightButton.showsMenuAsPrimaryAction = true
        return navBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.sectionHeadersPinToVisibleBounds = true
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(white: 0.97, alpha: 1)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HistoryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HistoryHeaderView.identifier)
        collectionView.register(HistoryCell.self, forCellWithReuseIdentifier: HistoryCell.identifier)
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchHistory()
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
    
    private func fetchHistory() {
        viewModel.fetchHistory { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print("Error fetching history: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func createMenu() -> UIMenu {
        let deleteAllAction = UIAction(title: "Delete All", image: UIImage(systemName: "trash")) { _ in
            self.deleteAll()
        }
        
        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash")) { _ in
            self.deleteSection()
        }
        
        return UIMenu(title: "", children: [deleteAllAction, deleteAction])
    }
    
    private func deleteAll() {
        viewModel.deleteAllSolutions { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.collectionView.reloadData()
                    self?.showAlert(title: "Success", message: "All history deleted successfully.")
                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    private func deleteSection() {
        isDeleteMode = true
        collectionView.reloadData()
    }
    
    private func exitDeleteMode() {
        isDeleteMode = false
        collectionView.reloadData()
    }
    
    private func deleteItem(at indexPath: IndexPath) {
        let key = viewModel.getSortedKeys()[indexPath.section]
        guard let solution = viewModel.getGroupedSolutions()[key]?[indexPath.item] else { return }
        
        viewModel.deleteSolution(solution) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.collectionView.deleteItems(at: [indexPath])
                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func rightButtonTapped() {
        customNavBar.rightButton.menu = createMenu()
    }
}

// MARK: - UICollectionViewDelegate
extension HistoryVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let key = viewModel.getSortedKeys()[indexPath.section]
        let solution = viewModel.getGroupedSolutions()[key]?[indexPath.item]
        
        let learnVC = LearnVC()
        if let solution = solution {
            learnVC.setupSolutionData(solution: solution)
        }
        navigationController?.pushViewController(learnVC, animated: true)
    }
    
}

// MARK: - UICollectionViewDataSource
extension HistoryVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.getSortedKeys().count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let key = viewModel.getSortedKeys()[section]
        return viewModel.getGroupedSolutions()[key]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HistoryHeaderView.identifier, for: indexPath) as! HistoryHeaderView
        let key = viewModel.getSortedKeys()[indexPath.section]
        header.configure(with: key)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryCell.identifier, for: indexPath) as! HistoryCell
        let key = viewModel.getSortedKeys()[indexPath.section]
        if let solution = viewModel.getGroupedSolutions()[key]?[indexPath.item] {
            cell.configure(with: solution, isDeleteMode: isDeleteMode) { [weak self] in
                self?.deleteItem(at: indexPath)
            }
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HistoryVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 32)
        return CGSize(width: width, height: width * 0.40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
}
