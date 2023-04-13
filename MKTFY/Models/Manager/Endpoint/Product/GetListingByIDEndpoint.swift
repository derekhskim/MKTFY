//
//  GetListingByIDEndpoint.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-10.
//

import Foundation

struct GetListingByIDEndpoint: Endpoint {
    let id: String!
    
    var path: String {
        return "/product/\(id ?? "No ID provided")"
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
