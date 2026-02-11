import Foundation

class SecureVault {
    private let key = CryptoHelper.getDeviceKey()
    static let shared = SecureVault()
    //let helper = newsCategory.shared
    
    func saveUser(_ user: UserData) {
        guard let key = key else{return}
        let encryptedName = CryptoHelper.encrypt(user.username, key: key) ?? ""
        let encryptedEmail = CryptoHelper.encrypt(user.email, key: key) ?? ""
        
        UserDefaults.standard.set(encryptedName, forKey: "username")
        UserDefaults.standard.set(encryptedEmail, forKey: "email")
        UserDefaults.standard.set(user.isSessionActive, forKey: "session")
        
    }

    func getUser() -> (name: String, email: String, session: Bool) {
        guard let key = key else{ return ("", "", false)}
        
        let encryptedName = UserDefaults.standard.string(forKey: "username") ?? ""
        let encryptedEmail = UserDefaults.standard.string(forKey: "email") ?? ""
        let session = UserDefaults.standard.bool(forKey: "session")
        
        let username = CryptoHelper.decrypt(encryptedName, key: key) ?? ""
        let email = CryptoHelper.decrypt(encryptedEmail, key: key) ?? ""
        
        //print(encryptedName)
        //print(encryptedEmail)
        //print(key)
        
        return (username, email, session)
    }
    
    /*func defaultCategorySetUp(){
        if let saved = UserDefaults.standard.stringArray(forKey: "newsCategory"){
            self.helper.category = saved
        } else{
            self.helper.category = ["Breaking News", "Business", "Technology", "Politics", "Sports"]
            saveCategory()
        }
    }
    
    func saveCategory(){
        UserDefaults.standard.set(helper.category, forKey: "newsCategory")
    }*/

    func clear() {
        if let bundleID = Bundle.main.bundleIdentifier{
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
}
