//
//  RegisterUserEndPoint.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-31.
//

import Foundation

struct RegisterUserEndpoint: Endpoint {
    let user: User
    
    var path: String {
        return "/user/register"
    }
    
    var httpMethod: HttpMethod {
        return .post
    }
    
    var headers: [String: String] {
        var headers = defaultHeaders
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"
        return headers
    }
    
    var body: Data? {
        return try? JSONEncoder().encode(user)
    }
}
