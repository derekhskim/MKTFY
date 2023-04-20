//
//  CancelSaleEndpoint.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-20.
//

import Foundation

struct CancelSaleEndpoint: Endpoint {
    let id: String
    
    var path: String {
        return "/Product/cancelsale/\(id)"
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
