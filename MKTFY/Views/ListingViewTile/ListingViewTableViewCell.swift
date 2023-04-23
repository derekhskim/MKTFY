//
//  ListingViewTableViewCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-21.
//

import UIKit

class ListingViewTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    private var shadowView: UIView!
    
    // MARK: - @IBOutlet
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shadowView = UIView()
        cellView.addSubview(shadowView)
        
        cellView.layer.cornerRadius = 20
        cellView.clipsToBounds = true
        
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.layer.cornerRadius = 20
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 1, height: 4)
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowRadius = 1
        
        itemImageView.layer.cornerRadius = 20
        itemImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        itemImageView.clipsToBounds = true
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 20, right: 10)
        backgroundColor = UIColor.appColor(LPColor.VerySubtleGray)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let insetFrame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 21, bottom: 20, right: 21))
        contentView.frame = insetFrame
        
        shadowView.frame = cellView.frame
    }
}
