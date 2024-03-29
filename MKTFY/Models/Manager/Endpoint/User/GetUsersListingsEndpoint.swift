//
//  GetUsersListingsEndpoint.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-13.
//

import Foundation

struct GetUsersListingsEndpoint: Endpoint {
    
    var path: String {
        return "/User/products"
    }
    
    var httpMethod: HttpMethod {
        return .get
    }
    
    var headers: [String: String] {
        var headers = defaultHeaders
        headers["Accept"] = "text/plain"
        return headers
    }
    
    var body: Data? {
        return nil
    }
}
