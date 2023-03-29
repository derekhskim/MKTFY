//
//  Auth0Manager.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/15.
//

import Auth0
import Foundation

class Auth0Manager {
    
    let audience = "http://mktfy.com"
    let auth0: Authentication!
    
    static let shared = Auth0Manager()
    
    init() {
        auth0 = Auth0.authentication()
    }
    
    func loginWithEmail(_ email: String, password: String, completion: @escaping (Bool, String?, Error?) -> Void) {
        
        auth0.login(
            usernameOrEmail: email,
            password: password,
            realmOrConnection: databaseConnection,
            audience: audience,
            scope: "openid profile"
        )
        .start { result in
            switch result {
            case .success(let credentials):
                print("Access Token: \(credentials.accessToken)")
                UserDefaults.standard.set(credentials.accessToken, forKey: "authenticationAPI")
                self.getUserInfo(accessToken: credentials.accessToken, completion: completion)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false, nil, error)
            }
        }
    }
        
    private func getUserInfo(accessToken: String, completion: @escaping (Bool, String?, Error?) -> Void) {
        auth0.userInfo(withAccessToken: accessToken)
            .start { (result: Result<UserInfo, AuthenticationError>) in
                switch result {
                case .success(let userInfo):
                    let userId = userInfo.sub
                    UserDefaults.standard.set(userId, forKey: "userId")
                    completion(true, userId, nil)

//                    NetworkManager.shared.getUsers { result in
//                        switch result {
//                        case .success(let success):
//                            print("Successfully fetched User Data: \(success)")
//                        case .failure(let error):
//                            print("Failed to fetch user: \(error)")
//                        }
//                    }
                case .failure(let error):
                    print("Failed to get user info: \(error)")
                    completion(false, nil, error)
                }
            }
    }
    
    func signup(email: String, password: String, firstName: String, lastName: String, phone: String, address: String, city: String, completion: @escaping (Bool, String?, Error?) -> Void) {
        
        let userMetadata = ["firstName" : firstName, "lastName" : lastName, "email" : email, "phone" : phone, "address" : address, "city" : city]
        
        auth0.signup(email: email, password: password, connection: databaseConnection, userMetadata: userMetadata)
            .start { result in
                switch result {
                case .success(let user):
                    print("User signed up: \(user)")
                    Auth0Manager.shared.loginWithEmail(email, password: password) { success, userId, error in
                        if success {
                            let user = User(id: userId!, firstName: firstName, lastName: lastName, email: email, phone: phone, address: address, city: city)
                            NetworkManager.shared.registerUser(user: user) { result in
                                switch result {
                                case .success(let success):
                                    if success {
                                        print("User registered successfully")
                                    }
                                case .failure(let error):
                                    print("Failed to register user: \(error)")
                                }
                            }
                            completion(true, userId, nil)
                        } else {
                            completion(false, nil, error)
                        }
                    }
                case .failure(let error):
                    print("Failed to sign up: \(error)")
                    completion(false, nil, error)
                }
            }
    }
    
    func resetPassword(email: String) {
        
        auth0.resetPassword(email: email, connection: databaseConnection)
            .start { result in
                switch result {
                case .success:
                    print("Email Sent Successfully")
                case .failure(let error):
                    print("Failed to send reset password email: \(error.localizedDescription)")
                }
            }
    }
    
    func signOut() {
        let clientId = Auth0.authentication().clientId
        let completeDomain = "https://\(devDomain)"
        let redirectUri = URL(string: "\(bundleId)://\(completeDomain)/ios/\(bundleId)/callback")!
        let logoutUrl = URL(string: "\(completeDomain)/v2/logout?client_id=\(clientId)&amp;returnTo=\(redirectUri.absoluteString)")!
        
        URLSession.shared.dataTask(with: logoutUrl) { data, response, error in
            if let error = error {
                print("Failed to log out: \(error.localizedDescription)")
            } else {
                print("User logged out successfully")
            }
        }.resume()
    }
    
}
