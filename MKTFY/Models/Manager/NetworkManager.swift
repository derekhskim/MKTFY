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
    
    struct EmptyResponse: Codable {}
    
    func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void, userDefaultsSaving: ((T) -> Void)? = nil) {
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
                
                switch response.statusCode {
                case 200..<300:
                    if data == nil || data?.isEmpty == true {
                        if T.self == EmptyResponse.self {
                            completion(.success(EmptyResponse() as! T))
                            return
                        } else {
                            print("Error: Did not receive data")
                            return
                        }
                    }
                    
                    guard let data = data else { return }
                    
                    do {
                        let responseObject = try JSONDecoder().decode(T.self, from: data)
                        userDefaultsSaving?(responseObject)
                        completion(.success(responseObject))
                    } catch {
                        print("Failed to decode JSON: \(error)")
                    }
                default:
                    print("Error: Received HTTP response with status code \(response.statusCode)")
                    let error = NSError(domain: NSURLErrorDomain, code: response.statusCode, userInfo: nil)
                    completion(.failure(error))
                }
                
            }
        }
        task.resume()
    }
}
