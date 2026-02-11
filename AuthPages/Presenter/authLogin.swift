//
//  authLogin.swift
//  EasyNews
//
//  Created by Mohamed Ali on 23/01/26.
//

import Foundation
import FirebaseAuth

protocol AuthService {
    func firebaseLogin(
        emailIn: String,
        passIn: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

class AuthManager: AuthService {
    func firebaseLogin(emailIn: String, passIn: String, completion: @escaping (Result<Void, Error>) -> Void){
        
        if emailIn.isEmpty{
            completion(.failure(AuthError.emptyEmail))
            return
        }
        if passIn.isEmpty{
            completion(.failure(AuthError.emptyPass))
            return
        }
        
        Auth.auth().signIn(withEmail: emailIn, password: passIn) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            print("Success")
            
            firebaseData { fetchData in
                if let user = fetchData{
                    let newUser = UserData(username: user.username, email: user.email, isSessionActive: true)
                    SecureVault.shared.saveUser(newUser)
                } else{
                    print("User data not found")
                }
            }
            completion(.success(()))
        }
    }
}
