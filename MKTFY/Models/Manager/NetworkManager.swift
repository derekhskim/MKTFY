//
//  NetworkManager.swift
//  MKTFY
//
//  Created by Derek Kim on 2023-03-23.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    struct ServerResponse: Codable {
        let status: String
    }
    
    func registerUser(user: User, completion: @escaping (Result<Bool, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/user/register")!
//        let token = UserDefaults.standard.string(forKey: "authenticationAPI") ?? ""
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
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
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(ServerResponse.self, from: data)
                    print("Server response: \(result)")
                    if result.status == "success" {
                        completion(.success(true))
                    } else {
                        let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to register user"])
                        completion(.failure(error))
                    }
                } catch let decodingError {
                    print("Decoding error: \(decodingError)")
                    completion(.failure(decodingError))
                }
            } else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

