//
//  OnboardingCell.swift
//  mathSolver
//
//  Created by FFK on 26.11.2024.
//

import UIKit
import NeonSDK

final class OnboardingCell: NeonCollectionViewCell<OnboardingContent> {
    static let identifier = Constants.Cells.OnboardingCell.identifier

    // MARK: - UI Components
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.poppinsBold(size: Constants.Layout.titleFontSize)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.poppinsRegular(size: Constants.Layout.descriptionFontSize)
        label.textColor = Constants.Colors.darkGrayColor
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(Constants.Layout.imageWidth * 1.5)
            make.height.equalTo(Constants.Layout.imageHeight * 1.5)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
    }

    // MARK: - Configuration
    override func configure(with object: OnboardingContent) {
        super.configure(with: object)
        imageView.image = object.image
        titleLabel.text = object.title
        descriptionLabel.text = object.description
    }
}
