//
//  SubscriptionOptionView.swift
//  mathSolver
//
//  Created by FFK on 28.11.2024.
//

import UIKit

final class SubscriptionOptionView: UIView {

    private let titleLabel: UILabel = UILabel()
    private let priceLabel: UILabel = UILabel()
    private let radioButton: UIButton = UIButton(type: .system)

    init(title: String, price: String, isSelected: Bool) {
        super.init(frame: .zero)
        setupView(title: title, price: price, isSelected: isSelected)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(title: String, price: String, isSelected: Bool) {
        titleLabel.text = title
        titleLabel.font = Constants.Fonts.poppinsRegular(size: 16)
        titleLabel.textColor = .black

        priceLabel.text = price
        priceLabel.font = Constants.Fonts.poppinsRegular(size: 16)
        priceLabel.textColor = .black

        radioButton.setImage(isSelected ? UIImage(systemName: "circle.inset.filled") : UIImage(systemName: "circle"), for: .normal)
        radioButton.tintColor = isSelected ? Constants.Colors.purpleColor : .gray

        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(radioButton)

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

        layer.cornerRadius = 25
        backgroundColor = isSelected ? UIColor(red: 240/255, green: 230/255, blue: 255/255, alpha: 1.0) : .white
    }

    func setSelected(_ isSelected: Bool) {
        radioButton.setImage(isSelected ? UIImage(systemName: "circle.inset.filled") : UIImage(systemName: "circle"), for: .normal)
        radioButton.tintColor = isSelected ? Constants.Colors.purpleColor : .gray
        backgroundColor = isSelected ? UIColor(red: 240/255, green: 230/255, blue: 255/255, alpha: 1.0) : .white
    }
}
