//
//  SearchResult.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-05.
//

import Foundation

// MARK: - SearchResult
struct SearchResult: Codable {
    let id, productName, description: String
    let price: Int
    let category, condition, status, address: String
    let city: String
    let sellerListingCount: JSONNull?
    let created, userID: String
    let sellerProfile: JSONNull?
    let images: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, productName, description, price, category, condition, status, address, city, sellerListingCount, created
        case userID = "userId"
        case sellerProfile, images
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(0)
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
