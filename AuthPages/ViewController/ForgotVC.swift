//
//  ForgotVC.swift
//  EasyNews
//
//  Created by Mohamed Ali on 12/02/26.
//

import UIKit
import FirebaseAuth

class ForgotVC: UIViewController {
    @IBOutlet weak var email: UITextField!
    let auth = Auth.auth()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendLink(_ sender: Any) {
        view.endEditing(true)

            guard let emailAddress = email.text, !emailAddress.isEmpty else {
                PopUpVC.showErrorPopup(from: self, message: "Email field is empty")
                return
            }

        auth.fetchSignInMethods(forEmail: emailAddress) { [weak self] (methods, error) in
            guard let self = self else { return }
            
            if let error = error {
                PopUpVC.showErrorPopup(from: self, message: error.localizedDescription)
                return
            }
            if let signInMethods = methods, !signInMethods.isEmpty {
                self.auth.sendPasswordReset(withEmail: emailAddress) { (error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            PopUpVC.showErrorPopup(from: self, message: error.localizedDescription)
                        } else {
                            PopUpVC.showSuccessPopup(from: self, message: "Reset link sent to your email")
                           }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    PopUpVC.showErrorPopup(from: self, message: "This email is not registered.")
                }
            }
        }
    }
    
    
}
