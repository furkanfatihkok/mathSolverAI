//
//  StepsCell.swift
//
//  Created by FFK on 2.12.2024.
//

import UIKit
import SnapKit

final class StepsCell: UICollectionViewCell {
    static let identifier = Constants.Cells.StepsCell.identifier
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = Constants.Colors.darkGrayColor.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.HomePage.SolutionVC.StepsTitle
        label.font = Constants.Fonts.poppinsBold(size: 16)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(stackView)
        
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(16)
            make.width.equalTo(320).priority(.high)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
    }
    
    func configure(steps: [String]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        steps.forEach { step in
            let stepLabel = UILabel()
            stepLabel.text = step
            stepLabel.font = Constants.Fonts.poppinsRegular(size: 16)
            stepLabel.numberOfLines = 0
            stepLabel.textAlignment = .left
            stepLabel.lineBreakMode = .byWordWrapping
            stackView.addArrangedSubview(stepLabel)
        }
    }
}
