//
//  GetUserEndPoint.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-31.
//

import Foundation

struct GetUserEndpoint: Endpoint {
    let userId: String
        
    var path: String {
        guard let encodedUserId = userId.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            return "/User/"
        }
        return "/User/\(encodedUserId)"
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
