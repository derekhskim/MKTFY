//
//  ListingViewTableViewCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-21.
//

import UIKit

class ListingViewTableViewCell: UITableViewCell {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(image: UIImage, date: String, title: String, price: String) {
        itemImageView.image = image
        dateLabel.text = date
        titleLabel.text = title
        priceLabel.text = price
    }
}
