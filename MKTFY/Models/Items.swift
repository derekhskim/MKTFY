//
//  CellItems.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-11.
//

import Foundation
import UIKit

class Items {
    var id: Int!
    var title: String!
    var imageName: UIImage!
    var price: Double!
    
    init(id: Int!, title: String!, imageName: UIImage, price: Double!) {
        self.id = id
        self.title = title
        self.imageName = imageName
        self.price = price
    }
    
    static func mockData() -> [Items] {
        let data = [
            Items(id: 1, title: "Pearl The cat: Donut edition", imageName: UIImage(named: "pearl_the_donut")!, price: 340.00),
            Items(id: 2, title: "Pearl The cat: Monster edition", imageName: UIImage(named: "pearl_the_monster")!, price: 340.00),
            Items(id: 3, title: "Pearl The cat: Christmas edition", imageName: UIImage(named: "pearl_the_christmas")!, price: 340.00),
            Items(id: 4, title: "Pearl The cat: Tiger edition", imageName: UIImage(named: "pearl_the_tiger")!, price: 340.00),
            Items(id: 5, title: "Pearl The cat: Halloween edition", imageName: UIImage(named: "pearl_the_halloween")!, price: 340.00),
            Items(id: 6, title: "Pearl The cat: Breakfast edition", imageName: UIImage(named: "pearl_the_breakfast")!, price: 340.00)
        ]
        
//        data.forEach({
//            let price = String("$" + String($0.price))
//
//            if let imageProperties = CGImageSourceCopyPropertiesAtIndex(CGImageSource.self as! CGImageSource, 0, nil) as Dictionary? {
//                let pixelWidth = imageProperties[kCGImagePropertyPixelWidth] as! CGFloat
//                let pixelHeight = imageProperties[kCGImagePropertyPixelHeight] as! CGFloat
//
//                $0.imageWidth = pixelWidth
//                $0.imageHeight = pixelHeight
//            }
//        })
        
        return data
    }
}
