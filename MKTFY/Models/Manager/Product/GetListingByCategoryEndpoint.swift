//
//  GetListingByCategoryEndpoint.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-08.
//

import Foundation

struct GetListingByCategoryEndpoint: Endpoint {
    let category: ListingCatergory
    
    var path: String {
        return "/product/category"
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
        return try? JSONEncoder().encode(category)
    }
}
