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
    
    private var deleteAction: (() -> Void)?
    
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
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .red
        button.isHidden = true
        button.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        return button
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
        contentView.addSubview(deleteButton)

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }

        questionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(8)
            make.trailing.equalTo(containerView.snp.trailing).offset(-8)
            make.width.height.equalTo(24)
        }
    }
    
    func configure(with question: Solution, isDeleteMode: Bool, deleteAction: @escaping () -> Void) {
        questionLabel.text = question.question
        self.deleteAction = deleteAction
        deleteButton.isHidden = !isDeleteMode
    }
    
    @objc private func handleDelete() {
        deleteAction?()
    }
}
