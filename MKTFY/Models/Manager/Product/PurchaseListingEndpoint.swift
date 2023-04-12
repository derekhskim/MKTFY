//
//  PurchaseListingEndpoint.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-11.
//

import Foundation

struct PurchaseListingEndpoint: Endpoint {
    let id: String!
    
    var path: String {
        return "/product/checkout/\(id ?? "No ID provided")"
    }
    
    var httpMethod: HttpMethod {
        return .put
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
