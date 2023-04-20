//
//  UpdateListingEndpoint.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-19.
//

import Foundation

struct UpdateListingEndpoint: Endpoint {
    let listingUpdate: ListingUpdate?
    
    var path: String {
        return "/Product"
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
        return try? JSONEncoder().encode(listingUpdate)
    }
}
