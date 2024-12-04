//
//  HistoryHeaderView.swift
//  mathSolver
//
//  Created by FFK on 3.12.2024.
//

import UIKit

final class HistoryHeaderView: UICollectionReusableView {
    static let identifier = Constants.Cells.HistoryHeaderView.identifier

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.poppinsRegular(size: 16)
        label.textColor = Constants.Colors.darkGrayColor
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
        addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with date: String) {
        dateLabel.text = date
    }
}
