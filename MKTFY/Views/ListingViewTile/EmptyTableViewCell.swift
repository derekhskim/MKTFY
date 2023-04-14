//
//  EmptyTableViewCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-13.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        let emptyView = UIView()
        emptyView.backgroundColor = UIColor.appColor(LPColor.VerySubtleGray)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emptyView)
        
        NSLayoutConstraint.activate([
            
            emptyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emptyView.topAnchor.constraint(equalTo: contentView.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            emptyView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
