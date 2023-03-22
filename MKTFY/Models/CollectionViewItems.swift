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
    var imageName: UIImage!
    var price: Double!
    var imageWidth: CGFloat = 1
    var imageHeight: CGFloat = 1
    
    init(id: Int!, title: String!, imageName: UIImage, price: Double!) {
        self.id = id
        self.title = title
        self.imageName = imageName
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
    
    static func mockData() -> [CollectionViewItems] {
        let data = [
            CollectionViewItems(id: 1, title: "Pearl The cat: Donut edition", imageName: UIImage(named: "pearl_the_donut")!, price: 340.00),
            CollectionViewItems(id: 2, title: "Pearl The cat: Monster edition", imageName: UIImage(named: "pearl_the_monster")!, price: 340.00),
            CollectionViewItems(id: 3, title: "Pearl The cat: Christmas edition", imageName: UIImage(named: "pearl_the_christmas")!, price: 340.00),
            CollectionViewItems(id: 4, title: "Pearl The Tiger", imageName: UIImage(named: "pearl_the_tiger")!, price: 340.00),
            CollectionViewItems(id: 5, title: "Pearl The cat: Halloween edition", imageName: UIImage(named: "pearl_the_halloween")!, price: 340.00),
            CollectionViewItems(id: 6, title: "Pearl The cat: Breakfast edition", imageName: UIImage(named: "pearl_the_breakfast")!, price: 340.00)
        ]
        
        return data
    }
}
