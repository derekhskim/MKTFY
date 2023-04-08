//
//  GetFAQEndpoint.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-07.
//

import Foundation

struct GetFAQEndpoint: Endpoint {
    var path: String {
        return "/FAQ"
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
