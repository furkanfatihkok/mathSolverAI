//
//  SettingsCell.swift
//  mathSolver
//
//  Created by FFK on 27.11.2024.
//

import UIKit
import NeonSDK

final class SettingsCell: NeonTableViewCell<SettingsOption> {

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Constants.Colors.darkGrayColor
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.poppinsBold(size: Constants.Layout.descriptionFontSize)
        label.textColor = .black
        return label
    }()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    // MARK: - Setup Views
    func setupViews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)

        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(20)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-20)
        }
    }

    // MARK: - Configure Cell
    override func configure(with object: SettingsOption) {
        super.configure(with: object)
        iconImageView.image = object.icon
        titleLabel.text = object.title
    }
}
