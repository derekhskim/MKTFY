//
//  AuthModel.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-07.
//

import Foundation

// MARK: - Password
struct Password: Codable {
    let newPassword, confirmPassword: String
}
