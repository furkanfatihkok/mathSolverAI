//
//  SettingsVC.swift
//  mathSolver
//
//  Created by FFK on 27.11.2024.
//

import UIKit
import NeonSDK

final class SettingsVC: UIViewController {

    // MARK: - Properties
    private let settingsOptions = SettingsOption.allCases

    // MARK: - UI Components
    private lazy var tableView: NeonTableView<SettingsOption, SettingsCell> = {
        let tableView = NeonTableView<SettingsOption, SettingsCell>(
            objects: settingsOptions,
            heightForRows: 80
        )
        tableView.delegate = self
        tableView.layer.cornerRadius = 20
        tableView.clipsToBounds = true
        return tableView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Setup Methods
    private func setupNavigationBar() {
        title = Constants.SettingsPage.title
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isHidden = false

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: Constants.Fonts.poppinsRegular(size: Constants.Layout.titleFontSize / 1.5) ?? UIFont.systemFont(ofSize: 18)
        ]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = Constants.Colors.purpleColor

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
    }

    private func setupViews() {
        view.backgroundColor = UIColor(red: 245/255, green: 247/255, blue: 252/255, alpha: 1.0)
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(350)
            make.height.equalTo(220)
        }
    }

    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - NeonTableView Delegate
extension SettingsVC: UITableViewDelegate {
    func didSelectItem(at index: Int, object: SettingsOption) {
        switch object {
        case .shareApp:
            print("Share app tapped")
        case .rateUs:
            print("Rate us tapped")
        case .contactUs:
            print("Contact us tapped")
        case .termsOfService:
            print("Terms of service tapped")
        case .privacyPolicy:
            print("Privacy policy tapped")
        }
    }
}
