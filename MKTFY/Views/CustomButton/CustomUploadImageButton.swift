//
//  CustomUploadImageButton.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-04.
//

import UIKit

class CustomPlusButton: UIButton {
    
    let addImageIcon = UIImageView()
    let instructionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.layer.borderColor = UIColor.appColor(LPColor.OccasionalPurple).cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        
        addImageIcon.image = UIImage(named: "add_image_camera")
        addImageIcon.translatesAutoresizingMaskIntoConstraints = false
        addImageIcon.contentMode = .center
        addSubview(addImageIcon)
        
        instructionLabel.text = "Choose up to 3 photos"
        instructionLabel.font = UIFont(name: "OpenSans-Regular", size: 14)
        instructionLabel.textAlignment = .center
        instructionLabel.textColor = UIColor.appColor(LPColor.OccasionalPurple)
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(instructionLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            addImageIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            addImageIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10),
            
            instructionLabel.topAnchor.constraint(equalTo: addImageIcon.bottomAnchor, constant: 8),
            instructionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
