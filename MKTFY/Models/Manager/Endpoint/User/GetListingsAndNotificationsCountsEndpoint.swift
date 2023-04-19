//
//  GetListingAndNotificationsCountsEndpoint.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-04-12.
//

import Foundation

class GetListingsAndNotificationsCountsEndpoint: Endpoint {
    var path: String {
        return "/user/notifications/count"
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
