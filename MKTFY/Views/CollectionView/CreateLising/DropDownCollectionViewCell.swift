//
//  DropDownCollectionViewCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-19.
//

import UIKit

class DropDownCollectionViewCell: UICollectionViewCell {

    var dropDownTextField: DropDownTextField!

    func configureCell(tag: Int, title: String, placeHolder: String, options: [String]) {
        dropDownTextField = DropDownTextField(frame: CGRect(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.height))
        dropDownTextField.title = title
        dropDownTextField.placeHolder = placeHolder
        dropDownTextField.textFieldTag = tag
        contentView.addSubview(dropDownTextField)
        
        dropDownTextField.dropDownHelper = DropDownHelper(delegate: dropDownTextField)
        dropDownTextField.dropDownHelper.selectionDelegate = dropDownTextField
        dropDownTextField.options = options
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        dropDownTextField.inputTextField.text = ""
        dropDownTextField.titleLabel.text = ""
    }
}

