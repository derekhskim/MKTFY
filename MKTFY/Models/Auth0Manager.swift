//
//  Auth0Manager.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/02/15.
//

import Auth0

class Auth0Manager {
    
    let auth0 = Auth0.authentication()
    let users = Users()
    
    
    func loginWithEmail(_ email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
                
        auth0.login(
            usernameOrEmail: email,
            password: password,
            realmOrConnection: "Username-Password-Authentication",
            audience: "https://dev-vtoay0l3h78iuz2e.us.auth0.com/api/v2/",
            scope: "openid profile"
        )
        .start { result in
            switch result {
            case .success(let credentials):
                print("Authenticated with Auth0: \(credentials)")
                completion(true, nil)
            case .failure(let error):
                print("Failed to authenticate with Auth0: \(error)")
                completion(false, error)
            }
        }
    }
    
    func signuptest(_ email: String, password: String) {

        auth0.signup(
            email: email,
            password: password,
            connection: "Username-Password-Authentication",
            userMetadata: ["firstName" : users.firstName, "lastName" : users.lastName, "email" : users.email, "phone" : users.phone, "address" : users.address, "city" : users.city])
            .start { result in
                switch result {
                case .success(let user):
                    print("User signed up: \(user)")
                case .failure(let error):
                    print("Failed to signup: \(error)")
                }
            }
    }
    
    func signup(email: String, password: String, firstName: String, lastName: String, phone: String, address: String, city: String, completion: @escaping (Bool, Error?) -> Void) {
        
        let metaData = ["firstName" : users.firstName, "lastName" : users.lastName, "email" : users.email, "phone" : users.phone, "address" : users.address, "city" : users.city]
        
            let auth0 = Auth0.authentication()
            let userMetadata = metaData
            auth0.signup(email: email, password: password, connection: "Username-Password-Authentication", userMetadata: userMetadata)
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

    
}
