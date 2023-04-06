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
    let search, city: String
    var category: String? = nil
}

// MARK: - Catergory
struct Catergory: Codable {
    let category, city: String
}

// MARK: - CreateListing
struct CreateListing: Codable {
    let productName, description: String
    let price: Double
    let category, condition, address, city: String
    let images: [String?]
}

// MARK: - ListingUpdate
struct ListingUpdate: Codable {
    let id, productName, description: String
    let price: Double
    let category, condition, address, city: String
    let images: [String?]
}

