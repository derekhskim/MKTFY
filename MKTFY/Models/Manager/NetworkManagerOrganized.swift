//
//  NetworkManagerOrganized.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-31.
//

import Foundation

class NetworkManagerOrganized {
    
    static let shared = NetworkManagerOrganized()
    
    private init() {}
    
    struct ServerResponse: Codable {
        let status: Int
    }
    
    func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = endpoint.url else {
            print("Error with URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        if let body = endpoint.body {
            request.httpBody = body
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Status code: \(response.statusCode)")
            }
            
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print("Received JSON: \(json)")
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }
        task.resume()
    }
}
