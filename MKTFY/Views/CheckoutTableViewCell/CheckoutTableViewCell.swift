//
//  CheckoutTableViewCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-11.
//

import UIKit

class CheckoutTableViewCell: UITableViewCell {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var imageHoldingView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupShadowView()
        selectionStyle = .none
    }
    
    func setupShadowView() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2
        layer.masksToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let shadowRect = CGRect(x: 0, y: bounds.height - 3, width: bounds.width, height: 3)
        layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
    }
}
