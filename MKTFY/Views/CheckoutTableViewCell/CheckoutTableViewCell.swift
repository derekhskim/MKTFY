//
//  CheckoutTableViewCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-11.
//

import UIKit

class CheckoutTableViewCell: UITableViewCell {

    let shadowLayer = CAGradientLayer()
    
    // MARK: - @IBOutlet
    @IBOutlet weak var imageHoldingView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureSeparatorShadow()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureSeparatorShadow() {
        contentView.layer.insertSublayer(shadowLayer, at: 0)
        shadowLayer.colors = [UIColor.black.withAlphaComponent(0.25).cgColor, UIColor.clear.cgColor]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let shadowHeight: CGFloat = 3
        shadowLayer.frame = CGRect(x: 0, y: contentView.bounds.height - shadowHeight, width: contentView.bounds.width, height: shadowHeight)
    }
    
}
