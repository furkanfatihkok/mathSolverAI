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
    
    private lazy var leftButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = Constants.Colors.purpleColor
        return button
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton(type: .system)
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
        addSubview(leftButton)
        addSubview(rightButton)
        
        leftButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Public Methods
    func configure(title: String, leftAction: Selector, rightAction: Selector, target: Any, leftImage: UIImage?, rightImage: UIImage?) {
        titleLabel.text = title
        leftButton.addTarget(target, action: leftAction, for: .touchUpInside)
        rightButton.addTarget(target, action: rightAction, for: .touchUpInside)
        if let leftImage = leftImage {
            leftButton.setImage(leftImage.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        if let rightImage = rightImage {
            rightButton.setImage(rightImage.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
}
