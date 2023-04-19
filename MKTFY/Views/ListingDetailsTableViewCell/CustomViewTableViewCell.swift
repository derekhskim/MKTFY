//
//  CustomViewTableViewCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-17.
//

import UIKit

class CustomViewTableViewCell: UITableViewCell {
    
    var TextFieldView: TextFieldWithError!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
