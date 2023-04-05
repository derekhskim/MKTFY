//
//  CustomButtonCollectionViewCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-04.
//

import UIKit

class CustomButtonCollectionViewCell: UICollectionViewCell {
    
    var button: Button!
    var onButtonTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        button = Button(frame: self.contentView.bounds)
        
        button.setTitle("Button Title", for: .normal)
        button.titleLabel?.font = UIFont(name: "OpenSans-bold", size: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.cornerRadius = 20
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        self.contentView.addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonTapped() {
        onButtonTapped?()
    }
}
