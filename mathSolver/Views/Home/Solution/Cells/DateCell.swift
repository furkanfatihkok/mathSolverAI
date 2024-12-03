//
//  DateCell.swift
//  mathSolver
//
//  Created by FFK on 2.12.2024.
//

import UIKit
import SnapKit

final class DateCell: UICollectionViewCell {
    static let identifier = Constants.Cells.DateCell.identifier

    // MARK: - UI Components
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.poppinsRegular(size: Constants.Layout.descriptionFontSize)
        label.textColor = .darkGray
        label.textAlignment = .left
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
        contentView.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(16)
        }
    }

    // MARK: - Configure Cell
    func configureDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d h:mm a"
        dateLabel.text = formatter.string(from: Date())
    }
}
