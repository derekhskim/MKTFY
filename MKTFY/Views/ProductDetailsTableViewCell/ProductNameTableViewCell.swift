//
//  ProductNameTableViewCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-11.
//

import UIKit

class ProductNameTableViewCell: UITableViewCell {
    let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTitleLabel() {
        let backgroundView = UIView()
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 20
        backgroundView.backgroundColor = UIColor.appColor(LPColor.VerySubtleGray)
        backgroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        contentView.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        backgroundView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -14),
            titleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 28),
            titleLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -19)
        ])
        
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "OpenSans-Regular", size: 24)
    }
}

