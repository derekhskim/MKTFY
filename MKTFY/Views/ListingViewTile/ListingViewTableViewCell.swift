//
//  ListingViewTableViewCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-21.
//

import UIKit

class ListingViewTableViewCell: UITableViewCell {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.cornerRadius = 20
        cellView.clipsToBounds = true
        itemImageView.layer.cornerRadius = 20
        itemImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        itemImageView.clipsToBounds = true
        selectionStyle = .none
        backgroundColor = UIColor.appColor(LPColor.VerySubtleGray)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 21),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -21)
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateNotificationCell(image: UIImage, date: String, title: String, price: String) {
        itemImageView.image = image
        dateLabel.text = date
        titleLabel.text = title
        priceLabel.text = price
    }
}
