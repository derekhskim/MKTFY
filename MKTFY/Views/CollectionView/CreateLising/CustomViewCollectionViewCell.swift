//
//  CustomViewCollectionViewCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-04.
//

import UIKit

class CustomViewCollectionViewCell: UICollectionViewCell {
    
    var view: TextFieldWithError!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        view = TextFieldWithError(frame: self.contentView.bounds)
        self.contentView.addSubview(view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        view.titleLabel.text = "I haven't been assigned yet!"
        view.inputTextField.placeholder = "I haven't been assigned yet!"
        view.inputTextField.backgroundColor = .clear
        view.errorLabel.text = ""
    }
    
}
