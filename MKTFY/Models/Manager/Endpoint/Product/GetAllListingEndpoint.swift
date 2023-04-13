//
//  GetAllListingEndpoint.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-08.
//

import Foundation

struct GetAllListingEndpoint: Endpoint {
    var path: String {
        return "/product"
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
