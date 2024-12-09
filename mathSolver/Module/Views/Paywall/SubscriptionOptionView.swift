//
//  SubscriptionOptionView.swift
//  mathSolver
//
//  Created by FFK on 28.11.2024.
//

import UIKit

final class SubscriptionOptionView: UIView {

    // MARK: - UI Components
    private let titleLabel: UILabel = UILabel()
    private let priceLabel: UILabel = UILabel()
    private let radioButton: UIButton = UIButton(type: .system)

    // MARK: - Initializers
    init(title: String, price: String, isSelected: Bool) {
        super.init(frame: .zero)
        setupView(title: title, price: price, isSelected: isSelected)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    private func setupView(title: String, price: String, isSelected: Bool) {
        // Configure title label
        titleLabel.text = title
        titleLabel.font = Constants.Fonts.poppinsRegular(size: 16)
        titleLabel.textColor = .black

        // Configure price label
        priceLabel.text = price
        priceLabel.font = Constants.Fonts.poppinsRegular(size: 16)
        priceLabel.textColor = .black

        // Configure radio button
        radioButton.setImage(isSelected ? UIImage(systemName: "circle.inset.filled") : UIImage(systemName: "circle"), for: .normal)
        radioButton.tintColor = isSelected ? Constants.Colors.purpleColor : .gray

        // Add subviews
        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(radioButton)

        // Set constraints
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }

        priceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(radioButton.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }

        radioButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }

        // Style view
        layer.cornerRadius = 25
        backgroundColor = isSelected ? UIColor(red: 240/255, green: 230/255, blue: 255/255, alpha: 1.0) : .white
    }

    // MARK: - Public Methods
    func setSelected(_ isSelected: Bool) {
        radioButton.setImage(isSelected ? UIImage(systemName: "circle.inset.filled") : UIImage(systemName: "circle"), for: .normal)
        radioButton.tintColor = isSelected ? Constants.Colors.purpleColor : .gray
        backgroundColor = isSelected ? UIColor(red: 240/255, green: 230/255, blue: 255/255, alpha: 1.0) : .white
    }
}
