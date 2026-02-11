import Foundation
import FirebaseFirestore
import FirebaseAuth

func firebaseData(completion: @escaping (Users?) -> Void){
    let db = Firestore.firestore()
    
    guard let uid = Auth.auth().currentUser?.uid else{
        completion(nil)
        return
    }
    
    db.collection("users").document(uid).getDocument{ (snapshot, error) in
        if let error = error{
            print("Retrieving error \(error)")
            completion(nil)
            return
        }
        if let snapshot = snapshot, snapshot.exists{
            do{
                let user = try snapshot.data(as: Users.self)
                completion(user)
                return
            }catch {
                print("Retrieivng error: \(error)")
                completion(nil)
            }
        }else {
            completion(nil)
        }
    }
    
}
