//
//  Auth0Manager.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/15.
//

import Auth0
import UIKit
import JWTDecode

class Auth0Manager {
    
    let auth0 = Auth0.authentication()
    let users = Users()
    
    
    func loginWithEmail(_ email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        
        auth0.login(
            usernameOrEmail: email,
            password: password,
            realmOrConnection: databaseConnection,
            audience: "https://\(domain)/api/v2/",
            scope: "openid profile"
        )
        .start { result in
            switch result {
            case .success(let credentials):
                print("accessToken : \(credentials.accessToken)")
                completion(true, nil)
            case .failure(let error):
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
        auth0.startPasswordless(email: email, type: .code, connection: emailConnection)
            .start { result in
                switch result {
                case .success:
                    print("Reset password email sent successfully")
                case .failure(let error):
                    print("Failed to send reset password email: \(error.localizedDescription)")
                }
            }
    }
}
