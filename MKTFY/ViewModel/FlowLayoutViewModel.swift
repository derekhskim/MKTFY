//
//  FlowLayoutModel.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-11.
//

import Foundation

class FlowLayoutViewModel {
    var items: [Items]
    
    init() {
        self.items = Items.mockData()
    }
}
