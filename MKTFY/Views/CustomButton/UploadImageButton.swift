//
//  UploadImageButton.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-01.
//

import UIKit

class UploadImageButton: UIButton {
    var chosenImages = [UIImage]() {
        didSet {
            updateAppearance()
        }
    }
    
    private let mainImageView = UIImageView()
    private let addImageIcon = UIImageView()
    private let instructionLabel = UILabel()
    
    private func updateAppearance() {
        print("Updating appearance with \(chosenImages.count) image(s)")
        
        if let firstImage = chosenImages.first {
            mainImageView.image = firstImage
            addImageIcon.isHidden = true
            instructionLabel.isHidden = true
            isUserInteractionEnabled = false
            layer.borderWidth = 0
        } else {
            mainImageView.image = nil
            addImageIcon.isHidden = false
            instructionLabel.isHidden = false
            setTitle("Choose up to 3 photos", for: .normal)
            isUserInteractionEnabled = true
            layer.borderWidth = 1
        }
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
        setTitleColor(.clear, for: .normal)
        titleLabel?.textAlignment = .center
        
        addSubview(mainImageView)
        addSubview(addImageIcon)
        addSubview(instructionLabel)
        
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.clipsToBounds = true
        
        addImageIcon.image = UIImage(named: "add_image_camera")
        addImageIcon.translatesAutoresizingMaskIntoConstraints = false
        addImageIcon.contentMode = .center
        
        instructionLabel.text = "Choose up to 3 photos"
        instructionLabel.textAlignment = .center
        instructionLabel.textColor = UIColor.appColor(LPColor.OccasionalPurple)
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            mainImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            mainImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            mainImageView.heightAnchor.constraint(equalToConstant: 283),
            
            addImageIcon.topAnchor.constraint(equalTo: topAnchor, constant: 42),
            addImageIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            addImageIcon.widthAnchor.constraint(equalToConstant: 44),
            addImageIcon.heightAnchor.constraint(equalToConstant: 44),
            
            instructionLabel.topAnchor.constraint(equalTo: addImageIcon.bottomAnchor, constant: 13),
            instructionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            instructionLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        updateAppearance()
    }
}
