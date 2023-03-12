//
//  CellItems.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-11.
//

import Foundation

class Items {
    var id: Int!
    var name: String!
    var description: String!
    var imageURL: String!
    var price: Double!
    
    init(id: Int!, name: String!, description: String!, imageURL: String!, price: Double!) {
        self.id = id
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.price = price
    }
    
    static func mockData() -> [Items] {
        
    }
}
