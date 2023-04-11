//
//  DescriptionTableViewCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-11.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {
    let descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureDescriptionLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureDescriptionLabel() {
        let backgroundView = UIView()
        
        contentView.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        backgroundView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
            descriptionLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 10),
            descriptionLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10)
        ])
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont(name: "OpenSans-Regular", size: 14)
    }
    
    
}
