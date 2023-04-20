//
//  CancelListingEndpoint.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-19.
//

import Foundation

struct CancelListingEndpoint: Endpoint {
    let id: String
    
    var path: String {
        return "/Product/cancel/\(id)"
    }
    
    var httpMethod: HttpMethod {
        return .put
    }
    
    var headers: [String: String] {
        var headers = defaultHeaders
        headers["Accept"] = "*/*"
        return headers
    }
    
    var body: Data? {
        return nil
    }
}
