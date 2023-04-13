//
//  UpdateUserEndpoint.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-31.
//

import Foundation

struct UpdateUserEndpoint: Endpoint {
    let user: User
    
    var path: String {
        return "/User"
    }
    
    var httpMethod: HttpMethod {
        return .put
    }
    
    var headers: [String: String] {
        var headers = defaultHeaders
        headers["Content-Type"] = "application/json"
        headers["Accept"] = "text/plain"
        return headers
    }
    
    var body: Data? {
        return try? JSONEncoder().encode(user)
    }
}
