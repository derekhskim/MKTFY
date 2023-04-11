//
//  CustomViewCollectionViewCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-04.
//

import UIKit

class CustomViewCollectionViewCell: UICollectionViewCell, DropDownDelegate {
    func setDropDownSelectedOption(_ option: String, forRow row: Int) {
        TextFieldView.inputTextField.text = option
        print("Options Selected: \(option)")
    }
    
    var TextFieldView: TextFieldWithError!
    var dropDownOptions: [String]? {
        didSet {
            if let options = dropDownOptions {
                let dropDownHelper = DropDownHelper(delegate: self)
                dropDownHelper.initializeImageDropDown(with: TextFieldView.inputTextField, options: options)
            } else {
                TextFieldView.inputTextField.rightView = nil
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        TextFieldView.inputTextField.rightViewMode = .always
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        TextFieldView = TextFieldWithError(frame: self.contentView.bounds)
        TextFieldView.view.backgroundColor = UIColor.appColor(LPColor.VerySubtleGray)
        self.contentView.addSubview(TextFieldView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        TextFieldView.titleLabel.text = "I haven't been assigned yet!"
        TextFieldView.inputTextField.placeholder = "I haven't been assigned yet!"
        TextFieldView.inputTextField.backgroundColor = .clear
        TextFieldView.view.backgroundColor = UIColor.appColor(LPColor.VerySubtleGray)
        TextFieldView.errorLabel.text = ""
        TextFieldView.inputTextField.rightViewMode = .never
    }
}
