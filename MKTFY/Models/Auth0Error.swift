//
//  Auth0Error.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/28.
//

import UIKit
import Auth0

enum Auth0Error: Error {
    case missingEmail
    case missingPassword
    case error(AuthenticationError)
}

extension Auth0Error: CustomStringConvertible {
    var description: String {
        switch self {
        case .missingEmail:
            return "Email is missing. Please provide email address."
        case .missingPassword:
            return "Password is missing. Please provide password"
        case .error(let error):
            return error.localizedDescription
        }
    }
}

extension Auth0Error: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .missingEmail:
            return "Missing Email"
        case .missingPassword:
            return "Missing Password"
        case .error(let error):
            return error.localizedDescription
        }
    }
}
