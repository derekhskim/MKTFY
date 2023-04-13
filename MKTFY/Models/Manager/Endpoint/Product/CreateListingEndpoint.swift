//
//  CreateListingEndpoint.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-05.
//

import Foundation

struct CreateListingEndpoint: Endpoint {
    let createLisitng: CreateListing
    
    var path: String {
        return "/product"
    }
    
    var httpMethod: HttpMethod {
        return .post
    }
    
    var headers: [String: String] {
        var headers = defaultHeaders
        headers["Accept"] = "text/plain"
        headers["Content-Type"] = "application/json"
        return headers
    }
    
    var body: Data? {
        return try? JSONEncoder().encode(createLisitng)
    }
}
