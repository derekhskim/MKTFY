//
//  ChangePasswordEndpoint.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-07.
//

import Foundation

struct ChangePasswordEndpoint: Endpoint {
    let password: Password
    
    var path: String {
        return "/auth/changepassword"
    }
    
    var httpMethod: HttpMethod {
        return .post
    }
    
    var headers: [String: String] {
        var headers = defaultHeaders
        headers["Accept"] = "*/*"
        headers["Content-Type"] = "application/json"
        return headers
    }
    
    var body: Data? {
        return try? JSONEncoder().encode(password)
    }
}
