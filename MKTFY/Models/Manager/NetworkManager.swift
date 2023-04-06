//
//  NetworkManager.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-31.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void, userDefaultsSaving: ((T) -> Void)? = nil) {
        guard let url = endpoint.url else {
            print("Error with URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        print("Request: \(request)\nHeaders: \(request.allHTTPHeaderFields ?? [:])\nBody: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "Unable to convert data to string")")
        
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
            
            print("Received JSON data: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")")

            do {
                let responseObject = try JSONDecoder().decode(T.self, from: data)
                userDefaultsSaving?(responseObject)
                completion(.success(responseObject))
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }
        task.resume()
    }
}
