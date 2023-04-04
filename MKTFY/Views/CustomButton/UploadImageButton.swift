//
//  UploadImageButton.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-01.
//

import UIKit

class UploadImageButton: UIButton {
    
    let addImageIcon = UIImageView()
    let instructionLabel = UILabel()
    
    // TODO: allow multiple selection of photo
    func updateAppearance() {
        print("Updating appearance with image(s)")
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        layer.borderColor = UIColor.appColor(LPColor.OccasionalPurple).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
        setTitleColor(.clear, for: .normal)
        titleLabel?.textAlignment = .center
        
        addSubview(addImageIcon)
        addSubview(instructionLabel)
        
        addImageIcon.image = UIImage(named: "add_image_camera")
        addImageIcon.translatesAutoresizingMaskIntoConstraints = false
        addImageIcon.contentMode = .center
        
        instructionLabel.text = "Choose up to 3 photos"
        instructionLabel.font = UIFont(name: "OpenSans-Regular", size: 14)
        instructionLabel.textAlignment = .center
        instructionLabel.textColor = UIColor.appColor(LPColor.OccasionalPurple)
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        setTitle("", for: .normal)
        setTitle("", for: .highlighted)
        
        NSLayoutConstraint.activate([
            addImageIcon.topAnchor.constraint(equalTo: topAnchor, constant: 42),
            addImageIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            addImageIcon.widthAnchor.constraint(equalToConstant: 44),
            addImageIcon.heightAnchor.constraint(equalToConstant: 44),
            
            instructionLabel.topAnchor.constraint(equalTo: addImageIcon.bottomAnchor, constant: 13),
            instructionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            instructionLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        addImageIcon.widthAnchor.constraint(equalToConstant: 100).isActive = true
        addImageIcon.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        updateAppearance()
    }    
}
