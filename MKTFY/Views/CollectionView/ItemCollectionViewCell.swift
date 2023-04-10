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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageViewItem.image = nil
    }
}
