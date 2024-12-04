//
//  HistoryCell.swift
//  mathSolver
//
//  Created by FFK on 3.12.2024.
//

import UIKit
import SnapKit

final class HistoryCell: UICollectionViewCell {
    static let identifier = Constants.Cells.HistoryCell.identifier
    
    private lazy var containerView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.poppinsRegular(size: 18)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
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
        containerView.addSubview(questionLabel)

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }

        questionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }

    func configure(with question: Solution) {
        questionLabel.text = question.question
    }
}
