//
//  Data+.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-18.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
