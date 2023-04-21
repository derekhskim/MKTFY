//
//  ItemCollectionViewCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-11.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imageViewItem: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // MARK: - awakeFromNib()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.mainView.layer.cornerRadius = 10
        self.mainView.layer.masksToBounds = true
        self.imageViewItem.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.imageViewItem.heightAnchor.constraint(equalToConstant: 172),
            self.imageViewItem.widthAnchor.constraint(equalToConstant: 172)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageViewItem.image = nil
        self.titleLabel.text = nil
        self.priceLabel.text = nil
    }
}
