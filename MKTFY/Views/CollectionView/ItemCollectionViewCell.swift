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
        
        titleLabel.font = titleFont
        priceLabel.font = priceFont
    }

    func updateData(data: Items) {
        self.priceLabel.text = "$ \(String(describing: data.price!))"
        self.titleLabel.text = data.title
        self.imageViewItem.image = data.imageName
    }
}
