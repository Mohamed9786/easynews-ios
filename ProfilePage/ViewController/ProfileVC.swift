//
//  MyTabBarViewController.swift
//  EasyNews
//
//  Created by Mohamed Ali on 22/01/26.
//

import UIKit
import FirebaseAuth
class ProfileVC: UIViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var email: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData(){
        let user = SecureVault.shared.getUser()
        self.userName.text = user.name
        self.email.text = user.email
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        ConfirmPopUpVC.showConfirmationPopup(from: self)
        /*do{
            try Auth.auth().signOut()
            SecureVault.shared.clear()
            if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil {
                DispatchQueue.main.async {
                    PopUpVC.showErrorPopup(from: self, message: "Logged out successfully") {
                        self.navigateToLogin()
                    }
                }
            }
        }
        catch let signOutError as NSError{
            print(signOutError)
        }*/
    }
    func navigateToLogin() {
            let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
            guard let vc = storyboard.instantiateViewController(
                withIdentifier: "LoginVC"
            ) as? LoginVC else { return }
            let navController = UINavigationController(rootViewController: vc)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController = navController
                sceneDelegate.window?.makeKeyAndVisible()
            }
        }
}
