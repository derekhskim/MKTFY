//
//  ItemCollectionViewCell.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-11.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imageViewItem: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // MARK: - awakeFromNib()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.mainView.layer.cornerRadius = 10
        self.mainView.layer.masksToBounds = true
        
        titleLabel.font = titleFont
        priceLabel.font = priceFont
    }
    
    func updateData(data: CollectionViewItems) {
        self.priceLabel.text = "$ \(String(describing: data.price!))"
        self.titleLabel.text = data.title
        
        if let imageURL = data.imageURL {
            downloadImage(from: imageURL) { [weak self] image in
                DispatchQueue.main.async {
                    self?.imageViewItem.image = image
                }
            }
        } else {
            self.imageViewItem.image = nil
        }
        
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error downloading image: \(String(describing: error))")
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
    
}
