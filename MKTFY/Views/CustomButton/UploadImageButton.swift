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
    private let xButton = UIImageView()
    private let additionalImageView1 = UIImageView()
    private let additionalImageView2 = UIImageView()
    private let imageStackView = UIStackView()
    private var additionalUploadImageButton: UploadImageButton?
    
    // TODO: Add subviews beneath for additional images view and add more photo up to 3 photos and disappear
    // TODO: allow multiple selection of photo
    func updateAppearance() {
        print("Updating appearance with \(chosenImages.count) image(s)")
        
        addImageIcon.isHidden = true
        instructionLabel.isHidden = true
        xButton.isHidden = false
        layer.borderWidth = 0
        
        switch chosenImages.count {
        case 1:
            mainImageView.image = chosenImages[0]
            additionalImageView1.isHidden = true
            additionalImageView2.isHidden = true
        case 2:
            mainImageView.image = chosenImages[0]
            additionalImageView1.image = chosenImages[1]
            additionalImageView1.isHidden = false
            additionalImageView2.isHidden = true
        case 3:
            mainImageView.image = chosenImages[0]
            additionalImageView1.image = chosenImages[1]
            additionalImageView2.image = chosenImages[2]
            additionalImageView1.isHidden = false
            additionalImageView2.isHidden = false
        default:
            mainImageView.image = nil
            additionalImageView1.isHidden = true
            additionalImageView2.isHidden = true
            addImageIcon.isHidden = false
            instructionLabel.isHidden = false
            xButton.isHidden = true
            setTitle("Choose up to 3 photos", for: .normal)
            isUserInteractionEnabled = true
            layer.borderWidth = 1
        }
        
        if chosenImages.count == 1, additionalUploadImageButton == nil {
            additionalUploadImageButton = UploadImageButton()
            addSubview(additionalUploadImageButton!)
            
            additionalUploadImageButton?.isUserInteractionEnabled = true
            
            additionalUploadImageButton?.translatesAutoresizingMaskIntoConstraints = false
            additionalUploadImageButton!.instructionLabel.text = "Add Photo"
            
            NSLayoutConstraint.activate([
                additionalUploadImageButton!.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 10),
                additionalUploadImageButton!.leadingAnchor.constraint(equalTo: leadingAnchor),
                additionalUploadImageButton!.heightAnchor.constraint(equalToConstant: 102),
                additionalUploadImageButton!.widthAnchor.constraint(equalToConstant: 102),
                
                additionalUploadImageButton!.addImageIcon.topAnchor.constraint(equalTo: additionalUploadImageButton!.topAnchor, constant: 14.5),
                additionalUploadImageButton!.addImageIcon.centerXAnchor.constraint(equalTo: additionalUploadImageButton!.centerXAnchor),
                additionalUploadImageButton!.addImageIcon.widthAnchor.constraint(equalToConstant: 44),
                additionalUploadImageButton!.addImageIcon.heightAnchor.constraint(equalToConstant: 44),
                
                additionalUploadImageButton!.instructionLabel.topAnchor.constraint(equalTo: additionalUploadImageButton!.addImageIcon.bottomAnchor, constant: 14),
                additionalUploadImageButton!.instructionLabel.centerXAnchor.constraint(equalTo: additionalUploadImageButton!.centerXAnchor),
            ])
        } else if chosenImages.count == 0 {
            additionalUploadImageButton?.removeFromSuperview()
            additionalUploadImageButton = nil
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
        layer.cornerRadius = 10
        setTitleColor(.clear, for: .normal)
        titleLabel?.textAlignment = .center
        
        addSubview(mainImageView)
        addSubview(addImageIcon)
        addSubview(instructionLabel)
        addSubview(xButton)
        
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.isUserInteractionEnabled = false
        mainImageView.clipsToBounds = true
        
        addImageIcon.image = UIImage(named: "add_image_camera")
        addImageIcon.translatesAutoresizingMaskIntoConstraints = false
        addImageIcon.contentMode = .center
        
        instructionLabel.text = "Choose up to 3 photos"
        instructionLabel.font = UIFont(name: "OpenSans-Regular", size: 14)
        instructionLabel.textAlignment = .center
        instructionLabel.textColor = UIColor.appColor(LPColor.OccasionalPurple)
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        xButton.image = UIImage(systemName: "x.circle.fill")
        xButton.tintColor = UIColor.appColor(LPColor.MistakeRed)
        xButton.translatesAutoresizingMaskIntoConstraints = false
        
        imageStackView.axis = .horizontal
        imageStackView.spacing = 10
        imageStackView.translatesAutoresizingMaskIntoConstraints = false
        imageStackView.addArrangedSubview(additionalImageView1)
        imageStackView.addArrangedSubview(additionalImageView2)
        addSubview(imageStackView)
        
        setTitle("", for: .highlighted)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(removeImage))
        xButton.isUserInteractionEnabled = true
        xButton.addGestureRecognizer(tapGestureRecognizer)
        
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
            instructionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            xButton.topAnchor.constraint(equalTo: topAnchor, constant: 11),
            xButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11),
            xButton.heightAnchor.constraint(equalToConstant: 21),
            xButton.widthAnchor.constraint(equalToConstant: 21),
            
            imageStackView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)
        ])
        
        addImageIcon.widthAnchor.constraint(equalToConstant: 100).isActive = true
        addImageIcon.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        updateAppearance()
    }
    
    @objc private func removeImage() {
        print("remove Image button tapped")
        
        if !chosenImages.isEmpty {
            chosenImages.removeFirst()
            updateAppearance()
        }
    }
}
