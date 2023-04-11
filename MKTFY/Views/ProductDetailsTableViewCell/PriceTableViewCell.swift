//
//  PriceTableViewCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-11.
//

import UIKit

class PriceTableViewCell: UITableViewCell {
    let priceLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configurePriceLabel()
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configurePriceLabel() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.appColor(LPColor.VerySubtleGray)
        
        contentView.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        backgroundView.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 14),
            priceLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -14),
            priceLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -28)
        ])
        
        priceLabel.font = UIFont(name: "OpenSans-Bold", size: 36)
        priceLabel.textColor = UIColor.appColor(LPColor.OccasionalPurple)
    }

}
