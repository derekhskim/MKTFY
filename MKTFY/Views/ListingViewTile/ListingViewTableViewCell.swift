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
    @IBOutlet weak var textHoldingView: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addDropShadow()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func addDropShadow() {
        cellView.layer.shadowColor = UIColor.black.cgColor
        cellView.layer.shadowOffset = CGSize(width: 0, height: 1)
        cellView.layer.shadowOpacity = 0.3
        cellView.layer.shadowRadius = 2
        cellView.layer.masksToBounds = false
        cellView.layer.cornerRadius = 20
        textHoldingView.layer.cornerRadius = 20
        itemImageView.layer.cornerRadius = 20
    }
    
    func updateNotificationCell(image: UIImage, date: String, title: String, price: String) {
        itemImageView.image = image
        dateLabel.text = date
        titleLabel.text = title
        priceLabel.text = price
    }
}
