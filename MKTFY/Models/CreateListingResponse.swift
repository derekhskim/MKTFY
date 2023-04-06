//
//  CreateListingResponse.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-05.
//

import Foundation

// MARK: - CreateListingResponse
struct CreateListingResponse: Codable {
    let id, productName, description: String
    let price: Int
    let category, condition, status, address: String
    let city: String
    let sellerListingCount: Int
    let created, userID: String
    let sellerProfile: SellerProfile
    let images: [String]

    enum CodingKeys: String, CodingKey {
        case id, productName, description, price, category, condition, status, address, city, sellerListingCount, created
        case userID = "userId"
        case sellerProfile, images
    }
}

// MARK: - SellerProfile
struct SellerProfile: Codable {
    let id, firstName, lastName, email: String
    let phone, address, city: String
}
