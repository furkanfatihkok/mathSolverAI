//
//  HistoryVC.swift
//  mathSolver
//
//  Created by FFK on 3.12.2024.
//

import UIKit

final class HistoryVC: BaseVC {
    
    // MARK: - Properties
    private let viewModel = HistoryViewModel()
    private var historyData: [String: [[String: Any]]] = [:]
    private var isDeleteMode: Bool = false
    private var isMenuVisible: Bool = false
    
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
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside(_:)))
        tap.cancelsTouchesInView = false
        return tap
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
        view.addGestureRecognizer(tapGesture)
        
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
        showLoadingAnimation()
        viewModel.fetchHistory { [weak self] result in
            DispatchQueue.main.async {
                self?.hideLoadingAnimation()
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
        let deleteAllAction = UIAction(title: "Delete All", image: UIImage(systemName: "trash")?.withTintColor(.red, renderingMode: .alwaysOriginal)) { _ in
            self.deleteAll()
            
        }
        
        let attributedTitle = NSMutableAttributedString(
            string: "Delete All",
            attributes: [ .foregroundColor: UIColor.red]
        )
        
        deleteAllAction.setValue(attributedTitle, forKey: "attributedTitle")
        
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
                    if self?.viewModel.getSortedKeys().isEmpty ?? true {
                        self?.navigateToEmptyVC()
                    }
                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    private func deleteItem(at indexPath: IndexPath) {
#warning("emptyVC ye geçiş sağlanmıyor kontrolünü sağla.")
        let key = viewModel.getSortedKeys()[indexPath.section]
        guard let solution = viewModel.getGroupedSolutions()[key]?[indexPath.item] else { return }
        
        viewModel.deleteSolution(solution) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.collectionView.deleteItems(at: [indexPath])
                    if self?.viewModel.getSortedKeys().isEmpty ?? true {
                        self?.navigateToEmptyVC()
                    } else {
                        self?.collectionView.reloadData()
                    }
                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    private func deleteSection() {
        isDeleteMode = !isDeleteMode
        collectionView.reloadData()
    }
    
    private func exitDeleteMode() {
        isDeleteMode = false
        collectionView.reloadData()
    }
    
    private func navigateToEmptyVC() {
        let emptyVC = EmptyVC()
        navigationController?.setViewControllers([emptyVC], animated: false)
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
        isMenuVisible.toggle()
        customNavBar.rightButton.menu = isMenuVisible ? createMenu() : nil
        
        if !isMenuVisible {
            isDeleteMode = false
            collectionView.reloadData()
        }
    }
    
    @objc private func handleTapOutside(_ sender: UITapGestureRecognizer) {
        if isMenuVisible {
            customNavBar.rightButton.menu = nil
            isMenuVisible = false
        }
        
        let locationInView = sender.location(in: view)
        let locationInCollectionView = sender.location(in: collectionView)
        
        if collectionView.indexPathForItem(at: locationInCollectionView) == nil {
            if isDeleteMode {
                isDeleteMode = false
                collectionView.reloadData()
            }
        }
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
