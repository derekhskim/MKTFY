//
//  User.swift
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

