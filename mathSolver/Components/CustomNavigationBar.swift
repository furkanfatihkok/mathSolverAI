//
//  CustomNavigationBar.swift
//  mathSolver
//
//  Created by FFK on 4.12.2024.
//

import UIKit

final class CustomNavigationBar: UIView {
    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.poppinsRegular(size: 18)
        label.textAlignment = .center
        label.textColor = Constants.Colors.darkGrayColor
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Constants.Colors.purpleColor
        return button
    }()

    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupViews() {
        backgroundColor = Constants.Colors.navBarColor
        addSubview(titleLabel)
        addSubview(backButton)
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Public Methods
    func configure(title: String, backAction: Selector, target: Any) {
        titleLabel.text = title
        backButton.addTarget(target, action: backAction, for: .touchUpInside)
    }
}
