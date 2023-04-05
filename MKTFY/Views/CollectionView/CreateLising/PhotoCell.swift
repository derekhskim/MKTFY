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
    var plusButton: CustomPlusButton?
    var onRemoveButtonTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photoImageView.isUserInteractionEnabled = true
        
        removeImageButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        removeImageButton.tintColor = .red
        removeImageButton.translatesAutoresizingMaskIntoConstraints = false
        removeImageButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        
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
}
