//
//  CustomTextViewCollectionViewCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-04.
//

import UIKit

class CustomTextViewCollectionViewCell: UICollectionViewCell {
    
    var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
