//
//  ImageCollectionViewCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-10.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    lazy var imageView = UIImageView()
        
        // MARK: - Properties
        static let cellId = "CarouselCell"
        
        // MARK: - Initializer
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupUI()
        }
}

private extension ImageCollectionViewCell {
    func setupUI() {
        backgroundColor = .clear
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 375)
        ])
        
        imageView.contentMode = .scaleAspectFit
    }
}

extension ImageCollectionViewCell {
    public func configure(image: UIImage?) {
        imageView.image = image
    }
}
