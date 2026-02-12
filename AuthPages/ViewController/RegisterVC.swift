//
//  SignUpVC.swift
//  EasyNews
//
//  Created by Mohamed Ali on 19/01/26.
//

import UIKit
import FirebaseAuth
class SignUpVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        loading.hidesWhenStopped = true
        
        email.delegate = self
        password.delegate = self
        userName.delegate = self
        email.returnKeyType = .done
        password.returnKeyType = .done
        userName.returnKeyType = .done
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func signupBtn(_ sender: Any) {
        let emailIn = email.text ?? ""
        let passIn = password.text ?? ""
        let userIn = userName.text ?? ""
        startLoading()
        firebaseSignUp(emailIn: emailIn, passIn: passIn, userName: userIn) {result in
            switch result {
            case .success():
                self.stopLoading()
                self.navToHome()
            case .failure(let error):
                self.stopLoading()
                PopUpVC.showErrorPopup(from: self, message: error.localizedDescription)
            }
        }
        
        
    }
    
    @IBAction func backToLogin(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        if let existVC = self.navigationController?.viewControllers.first(where: { $0 is LoginVC}){
            self.navigationController?.popToViewController(existVC, animated: false)
        }
        else{
            if let nv = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC{
                self.navigationController?.pushViewController(nv, animated: false)
            }
        }
    }
    
    func navToHome(){
        let storyboard = UIStoryboard(name: "NewsPage", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "NewsVC") as? NewsVC {
            let nav = UINavigationController(rootViewController: vc)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate {
                
                sceneDelegate.window?.rootViewController = nav
                sceneDelegate.window?.makeKeyAndVisible()
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersInRanges ranges: [NSValue], replacementString string: String) -> Bool {
        if textField == userName{
            return true
        }
        if textField == password{
            if string.isEmpty{
                return true
            }
            let maxL = 9
            if let txt = textField.text{
                if txt.count > 9{
                    return false
                }
                return true
            }
        }
        
        if string.isEmpty{ return true}
        
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@.")
        let charset = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: charset)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        email.resignFirstResponder()
        password.resignFirstResponder()
        userName.resignFirstResponder()
        return true
    }
    
    func startLoading() {
        let blur = UIView(frame: view.bounds)
        blur.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        view.addSubview(blur)
        loading.startAnimating()
        view.isUserInteractionEnabled = false
    }

    func stopLoading() {
        loading.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
}
