//
//  Auth0Manager.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/15.
//

import Auth0
import Foundation

class Auth0Manager {
    
    let audience = "https://\(devDomain)/api/v2/"
    let auth0: Authentication!
    let users = Users()
    
    static let shared = Auth0Manager()
    
    init() {
        auth0 = Auth0.authentication()
    }
    
    func loginWithEmail(_ email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        
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
                completion(true, nil)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false, error)
            }
        }
    }
    
    func signup(email: String, password: String, firstName: String, lastName: String, phone: String, address: String, city: String, completion: @escaping (Bool, Error?) -> Void) {
        
        let userMetadata = ["firstName" : firstName, "lastName" : lastName, "email" : email, "phone" : phone, "address" : address, "city" : city]
        
        auth0.signup(email: email, password: password, connection: databaseConnection, userMetadata: userMetadata)
            .start { result in
                switch result {
                case .success(let user):
                    print("User signed up: \(user)")
                    completion(true, nil)
                case .failure(let error):
                    print("Failed to sign up: \(error)")
                    completion(false, error)
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
        
//        auth0.startPasswordless(email: email, type: .code, connection: emailConnection)
//            .start { result in
//                switch result {
//                case .success:
//                    print("Reset password email sent successfully")
//                case .failure(let error):
//                    print("Failed to send reset password email: \(error.localizedDescription)")
//                }
//            }
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
