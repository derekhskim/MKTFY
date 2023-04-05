//
//  Models.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-18.
//

import Foundation

// MARK: - User
struct User: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let phone: String
    let address: String
    let city: String
}

// MARK: - Search
struct Search: Codable {
    let search: String
    let city: String
    var category: String? = nil
}

// MARK: - Catergory
struct Catergory: Codable {
    let category: String
    let city: String
}

// MARK: - ListingUpdate
struct ListingUpdate: Codable {
    let id: String
    let productName: String
    let description: String
    let price: Int
    let category: String
    let condition: String
    let address: String
    let city: String
    let images: [String]
}

