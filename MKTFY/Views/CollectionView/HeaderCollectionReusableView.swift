//
//  HeaderCollectionReusableView.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-13.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var headerTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCityLabel(city: String) {
        cityLabel.text = city
    }
    
    func updateTitleLabel(title: String) {
        headerTitle.text = title
    }
    
}
