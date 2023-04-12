//
//  DetailsLabelTableViewCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-11.
//

import UIKit

class DetailsLabelTableViewCell: UITableViewCell {
    let detailsLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureDetailsLabel()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureDetailsLabel() {
        contentView.addSubview(detailsLabel)
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            detailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            detailsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
        ])
        
        detailsLabel.font = UIFont(name: "OpenSans-Bold", size: 16)
        detailsLabel.textColor = UIColor.appColor(LPColor.OccasionalPurple)
    }
}
