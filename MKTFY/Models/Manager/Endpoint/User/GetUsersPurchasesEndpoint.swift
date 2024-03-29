//
//  GetUsersPurchasesEndpoint.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-13.
//

import Foundation

struct GetUsersPurchasesEndpoint: Endpoint {
    var path: String {
        return "/User/purchases"
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
