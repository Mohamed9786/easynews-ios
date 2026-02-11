//
//  ConfirmPopUpVC.swift
//  EasyNews
//
//  Created by Mohamed Ali on 11/02/26.
//

import UIKit
import FirebaseAuth
class ConfirmPopUpVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }
    
    static func showConfirmationPopup(from vc: UIViewController, completion: (() -> Void)? = nil) {
        let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
        let popupVC = storyboard.instantiateViewController(
            withIdentifier: "ConfirmPopUpVC"
        ) as! ConfirmPopUpVC

        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve

        vc.present(popupVC, animated: true)
    }
    
    
    @IBAction func logoutBtn(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            SecureVault.shared.clear()
            DispatchQueue.main.async {
                self.navigateToLogin()
            }
        }
        catch let signOutError as NSError{
            print(signOutError)
        }
        dismiss(animated: false)
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: false)
    }
    
    private func navigateToLogin() {
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
