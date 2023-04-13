//
//  CellItems.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-11.
//

import Foundation
import UIKit

class CollectionViewItems {
    var id: String!
    var title: String!
    var imageURL: URL?
    var price: Double!
    var imageWidth: CGFloat = 1
    var imageHeight: CGFloat = 1
    
    let titleFont: UIFont = UIFont(name: "OpenSans-Regular", size: 14)!
    let priceFont: UIFont = UIFont(name: "OpenSans-Bold", size: 14)!
    
    init(id: String!, title: String!, imageURL: URL?, price: Double!) {
        self.id = id
        self.title = title
        self.imageURL = imageURL
        self.price = price
    }
    
    func imageScaleHeight(cellWidth: CGFloat) -> CGFloat {
        let imageScale = cellWidth / imageWidth
        
        let imageHeight = imageHeight * imageScale
        return imageHeight
    }
    
    func height(cellWidth: CGFloat) -> CGFloat {
        let titleHeight = self.title!.height(constraintedWidth: cellWidth, font: titleFont)
        let priceHeight = "\(self.price!)".height(constraintedWidth: cellWidth, font: priceFont)
        
        let imageScale = cellWidth / imageWidth
        
        let imageHeight = imageHeight * imageScale
        return 20 + titleHeight + priceHeight + imageHeight
    }
    
}
