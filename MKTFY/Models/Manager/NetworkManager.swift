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
        let status: Int
    }
    
    // MARK: - Register User via "POST" Method
    func registerUser(user: User, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/user/register") else { return }
        guard let token = UserDefaults.standard.string(forKey: "authenticationAPI") else { return }
        
        guard let jsonData = try? JSONEncoder().encode(user) else {
            print("Error: Trying to convert model to JSON Data")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
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
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    print("Error: Couldn't print JSON in String")
                    return
                }
                print(prettyPrintedJson)
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }
        task.resume()
    }
    
    // MARK: - Get User via "GET" Method
    func getUsers() {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else { return }
        guard let url = URL(string: "\(baseURL)/user/\(userId)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error calling GET: \(String(describing: error?.localizedDescription))")
                return
            }
            
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Status code: \(response.statusCode)")
            }
            
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    print("Error: Cannot print JSON in String")
                    return
                }
                
                print(prettyPrintedJson)
            } catch {
                print("Error: Trying to convert JSON data to String")
                return
            }
        }
        task.resume()
    }
    
    // MARK: - Update user via "PUT" Method
    func updateUsers() {
        guard let url = URL(string: "\(baseURL)/user") else { return }
        
        
    }
}

