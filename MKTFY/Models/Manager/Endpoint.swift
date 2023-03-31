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
    var defaultHeaders: [String: String] {
            var headers: [String: String] = [:]
            if let token = UserDefaults.standard.string(forKey: "authenticationAPI") {
                headers["Authorization"] = "Bearer \(token)"
            }
            return headers
    }
}
