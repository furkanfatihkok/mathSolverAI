//
//  OnboardingVC.swift
//  mathSolver
//
//  Created by FFK on 20.11.2024.
//

import UIKit
import NeonSDK

final class OnboardingVC: UIViewController {

    private let onboardingData = OnboardingContent.allCases
    private var currentPage: Int = 0
    
    private lazy var collectionView: NeonCollectionView<OnboardingContent, OnboardingCell> = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = NeonCollectionView<OnboardingContent, OnboardingCell>(
            objects: onboardingData,
            leftPadding: 0,
            rightPadding: 0,
            horizontalItemSpacing: 0,
            heightForItem: UIScreen.main.bounds.height
        )
        collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var pageControl: NeonPageControlV1 = {
        let pageControl = NeonPageControlV1()
        pageControl.numberOfPages = onboardingData.count
        pageControl.radius = 4
        pageControl.padding = 8
        pageControl.currentPageTintColor = UIColor.purple
        pageControl.tintColor = .lightGray
        return pageControl
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton.onboardingButton(title: .continueButton)
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        view.backgroundColor = Constants.Colors.backgroundColor
        navigationItem.hidesBackButton = true
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(actionButton)
        
        collectionView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(pageControl.snp.top).offset(-20)
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(actionButton.snp.top).offset(-20)
            make.centerX.equalToSuperview()
        }
        
        actionButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalToSuperview()
            make.height.equalTo(Constants.Layout.buttonHeightFixed)
            make.width.equalTo(Constants.Layout.buttonWidthFixed)
        }
    }
    
    @objc private func continueButtonTapped() {
        if currentPage < onboardingData.count - 1 {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            pageControl.set(progress: currentPage, animated: true)
        } else {
            navigateToPaywall()
        }
    }

    private func navigateToPaywall() {
        let paywallVC = PaywallVC()
        paywallVC.modalPresentationStyle = .fullScreen
        present(paywallVC, animated: true, completion: nil)
    }
}

// MARK: - CollectionView DelegateFlowLayout
extension OnboardingVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.frame.width > 0 else { return }
        let page = Int((scrollView.contentOffset.x / scrollView.frame.width).rounded())
        if page != currentPage {
            currentPage = page
            pageControl.set(progress: page, animated: true)
        }
    }
}
