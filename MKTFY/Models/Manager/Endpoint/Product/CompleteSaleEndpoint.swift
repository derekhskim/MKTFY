//
//  CompleteSaleEndpoint.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-20.
//

import Foundation

struct CompleteSaleEndpoint: Endpoint {    
    let id: String
    
    var path: String {
        return "/Product/complete/\(id)"
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
