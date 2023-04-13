//
//  PhotoCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-04.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    let removeImageButton = UIButton()
    var plusButton: DKCustomPlusButton?
    var smallPlusButton: DKCustomPlusButton?
    var onRemoveButtonTapped: (() -> Void)?
    var onUploadImageButtonTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photoImageView.isUserInteractionEnabled = true
        
        removeImageButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        removeImageButton.tintColor = .red
        removeImageButton.translatesAutoresizingMaskIntoConstraints = false
        removeImageButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        
        plusButton = DKCustomPlusButton(frame: photoImageView.bounds)
        if let plusButton = plusButton {
            plusButton.translatesAutoresizingMaskIntoConstraints = false
            plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
            
            contentView.addSubview(plusButton)
            
            NSLayoutConstraint.activate([
                plusButton.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor),
                plusButton.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor),
                plusButton.topAnchor.constraint(equalTo: photoImageView.topAnchor, constant: 10),
                plusButton.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor)
            ])
        }
        
        smallPlusButton = DKCustomPlusButton(frame: photoImageView.bounds)
        if let smallPlusButton = smallPlusButton {
            smallPlusButton.translatesAutoresizingMaskIntoConstraints = false
            smallPlusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
            smallPlusButton.instructionLabel.text = "Add Photo"
            
            contentView.addSubview(smallPlusButton)
            
            NSLayoutConstraint.activate([
                smallPlusButton.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor, constant: 10),
                smallPlusButton.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -10),
                smallPlusButton.topAnchor.constraint(equalTo: photoImageView.topAnchor, constant: 11.5),
                smallPlusButton.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: -11.5)
            ])
        }
        
        contentView.addSubview(removeImageButton)
        
        NSLayoutConstraint.activate([
            removeImageButton.topAnchor.constraint(equalTo: photoImageView.topAnchor, constant: 5),
            removeImageButton.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -5),
            removeImageButton.widthAnchor.constraint(equalToConstant: 25),
            removeImageButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    @objc private func removeButtonTapped() {
        onRemoveButtonTapped?()
    }
    
    @objc private func plusButtonTapped() {
        onUploadImageButtonTapped?()
    }
}
