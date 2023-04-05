//
//  SearchResultsEndpoint.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-05.
//

import Foundation

struct SearchEndpoint: Endpoint {
    let search: Search
    
    var path: String {
        return "/product/search"
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
        return try? JSONEncoder().encode(search)
    }
}
