//
//  Endpoint.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-31.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var httpMethod: HttpMethod { get }
    var headers: [String: String] { get }
    var body: Data? { get }
    var url: URL? { get }
}

extension Endpoint {
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    
    var headers: [String: String] {
        var defaultHeaders: [String: String] = [:]
        if let token = UserDefaults.standard.string(forKey: "authenticationAPI") {
            defaultHeaders["Authorization"] = "Bearer \(token)"
        }
        return defaultHeaders
    }
}
