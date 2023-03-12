//
//  ItemCollectionViewCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-11.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.layer.cornerRadius = 10
        
    }

}
