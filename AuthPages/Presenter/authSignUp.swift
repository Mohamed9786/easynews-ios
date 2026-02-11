import Foundation
import FirebaseAuth
import FirebaseFirestore
func firebaseSignUp(emailIn: String, passIn: String, userName: String, completion: @escaping (Result<Void, Error>) -> Void){
    
    if userName.isEmpty{
        completion(.failure(AuthError.emptyName))
        return
    }
    if emailIn.isEmpty{
        completion(.failure(AuthError.emptyEmail))
        return
    }
    if passIn.isEmpty{
        completion(.failure(AuthError.emptyPass))
        return
    }
    
    Auth.auth().createUser(withEmail: emailIn, password: passIn) { authResult, error in
        if let error = error{
            print("Error: \(error)")
            completion(.failure(error))
            return
        }
        guard let uid = authResult?.user.uid else {return }
        let db = Firestore.firestore()
        db.collection("users").document(uid).setData([
            "username" : userName,
            "email" : emailIn,
            "uid" : uid
        ]){error in
            if let error = error{
                print("Firestore error \(error)")
                completion(.failure(error))
            }
            else{
                let newUser = UserData(username: userName, email: emailIn, isSessionActive: true)
                SecureVault.shared.saveUser(newUser)
                completion(.success(()))
            }}
    }
}
