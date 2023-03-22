//
//  FlowLayoutModel.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-11.
//

import Foundation

class FlowLayoutViewModel {
    var items: [CollectionViewItems]
    
    init() {
        self.items = CollectionViewItems.mockData()
    }
}
