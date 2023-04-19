//
//  GetDealsEndPoint.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-18.
//

import Foundation

struct GetDealsEndpoint: Endpoint {
    var path: String {
        return "/product/deals"
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
