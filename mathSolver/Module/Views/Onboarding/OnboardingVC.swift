//
//  OnboardingVC.swift
//  mathSolver
//
//  Created by FFK on 20.11.2024.
//

import UIKit
import NeonSDK

final class OnboardingVC: UIViewController {

    // MARK: - Properties
    private let onboardingData = OnboardingContent.allCases
    private var currentPage: Int = 0
    private var isScrollingProgrammatically: Bool = false

    // MARK: - UI Components
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

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - pageControl.frame.height - 150)
    }

    // MARK: - Setup Methods
    private func setupViews() {
        view.backgroundColor = Constants.Colors.navBarColor
        navigationItem.hidesBackButton = true
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(actionButton)

        collectionView.snp.makeConstraints { make in
             make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
             make.left.right.equalToSuperview()
             make.bottom.equalTo(pageControl.snp.top).offset(-20)
        }

        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(actionButton.snp.top).offset(-10)
            make.centerX.equalToSuperview()
        }

        actionButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalToSuperview()
            make.height.equalTo(Constants.Layout.buttonHeightFixed)
            make.width.equalTo(Constants.Layout.buttonWidthFixed)
        }
    }

    // MARK: - Action Methods
    @objc private func continueButtonTapped() {
        UserDefaults.standard.set(true, forKey: "isOnboardingCompleted")
        UserDefaults.standard.synchronize()
        
        if currentPage < onboardingData.count - 1 {
            currentPage += 1
            let targetOffsetX = CGFloat(currentPage) * collectionView.frame.width
            isScrollingProgrammatically = true
            UIView.animate(withDuration: 0.3, animations: {
                self.collectionView.contentOffset.x = targetOffsetX
            }) { _ in
                self.pageControl.set(progress: self.currentPage, animated: true)
                self.isScrollingProgrammatically = false
            }
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
        guard !isScrollingProgrammatically, scrollView.frame.width > 0 else { return }
        let page = Int((scrollView.contentOffset.x / scrollView.frame.width).rounded())
        if page != currentPage {
            currentPage = page
            pageControl.set(progress: page, animated: true)
        }
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let correctOffsetX = CGFloat(currentPage) * collectionView.frame.width
        if scrollView.contentOffset.x != correctOffsetX {
            scrollView.setContentOffset(CGPoint(x: correctOffsetX, y: 0), animated: false)
        }
    }
}
