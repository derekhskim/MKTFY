//
//  ItemCollectionViewCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-11.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {

    // MARK: - @IBOutlet
    @IBOutlet weak var imageViewItem: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // MARK: - awakeFromNib()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.layer.cornerRadius = 10
    }

    func updateData(data: Items) {
        self.priceLabel.text = "$ \(String(describing: data.price!))"
        self.titleLabel.text = data.title
        self.imageViewItem.image = data.imageName
    }
}
