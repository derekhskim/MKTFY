//
//  NotificationTableViewCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-21.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var notificationTileView: UIView!
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var textHoldingView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - @IBInspectable
    @IBInspectable var title: String = "Title" {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable var date: String = "Date" {
        didSet {
            dateLabel.text = date
        }
    }
    
    @IBInspectable var viewBackgroundColor: UIColor = .white {
        didSet {
            notificationTileView.backgroundColor = viewBackgroundColor
            
            textHoldingView.backgroundColor = viewBackgroundColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addDropShadow()
    }
    
    func addDropShadow() {
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowRadius = 2
        contentView.layer.masksToBounds = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
