//
//  CellItems.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-11.
//

import Foundation
import UIKit

let titleFont: UIFont = .systemFont(ofSize: 14, weight: .regular)
let priceFont: UIFont = .systemFont(ofSize: 14, weight: .bold)

class CollectionViewItems {
    var id: Int!
    var title: String!
    var imageURL: URL?
    var price: Double!
    var imageWidth: CGFloat = 1
    var imageHeight: CGFloat = 1
    
    init(id: Int!, title: String!, imageURL: URL?, price: Double!) {
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
        return 25 + titleHeight + priceHeight + imageHeight
    }
    
}
