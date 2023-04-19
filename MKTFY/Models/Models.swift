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
struct ListingCatergory: Codable {
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

// MARK: - Password
struct Password: Codable {
    let newPassword, confirmPassword: String
}

// MARK: - Notification
struct Notification {
    let title: String
    let date: String
    
    init(title: String, date: String) {
        self.title = title
        self.date = date
    }
    
    init(from notificationData: NotificationData) {
        self.title = notificationData.message
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        dateFormatter.locale = Locale(identifier: "en_US")
        if let date = dateFormatter.date(from: notificationData.created) {
            dateFormatter.dateFormat = "MMMM d, yyyy"
            self.date = dateFormatter.string(from: date)
        } else {
            self.date = ""
        }
    }
}

// MARK: - NotificationResponse
struct NotificationResponse: Codable {
    let new, seen: [NotificationData]
}

// MARK: - NotificationData
struct NotificationData: Codable {
    let id, message, created: String
    let read: Bool
}

// MARK: - FAQResponse
struct FAQResponse: Codable {
    let id, question, answer: String
}

typealias FAQResponses = [FAQResponse]

// MARK: - ImageResponse
struct ImageResponse: Codable {
    let id: String
}

// MARK: - ListingsAndNotificationsCountResponse
struct ListingsAndNotificationsCountResponse: Codable {
    let unreadNotifications, pendingListings: Int
}

// MARK: - ListingResponse
struct ListingResponse: Codable {
    let id, productName, description: String
    let price: Double
    let category, condition, status, address: String
    let city: String
    let sellerListingCount: Int?
    let created, userID: String
    let sellerProfile: SellerProfile?
    let images: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, productName, description, price, category, condition, status, address, city, sellerListingCount, created
        case userID = "userId"
        case sellerProfile, images
    }
}

// MARK: - SellerProfile
struct SellerProfile: Codable {
    let id, firstName, lastName, email: String?
    let phone, address, city: String?
}

typealias ListingResponses = [ListingResponse]
