//
//  ViewController.swift
//  EasyNews
//
//  Created by Mohamed Ali on 19/01/26.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    private var blurView: UIView?
    @IBOutlet weak var loading: UIActivityIndicatorView!
    var authService: AuthService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if authService == nil {
            authService = AuthManager()
        }
        loading.hidesWhenStopped = true
        
        email.delegate = self
        password.delegate = self
        email.returnKeyType = .done
        password.returnKeyType = .done
        navigationController?.navigationBar.barStyle = .black
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        let emailStr = email.text ?? ""
        let passStr = password.text ?? ""
        startLoading()
        authService.firebaseLogin(emailIn: emailStr, passIn: passStr){ result in
            switch result{
            case .success:
                self.stopLoading()
                self.navToHome1(in: self.view.window)
            case .failure(let error):
                self.stopLoading()
                self.showError(error.localizedDescription)
                print("Fail received")
            }
        }
    }
            
    @IBAction func navRegisterBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        if let existVC = self.navigationController?.viewControllers.first(where: { $0 is SignUpVC}){
            self.navigationController?.popToViewController(existVC, animated: false)
        }
        else{
            if let nv = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC{
                self.navigationController?.pushViewController(nv, animated: false)
            }
        }
    }
    
    func navToHome1(in window: UIWindow? = nil) -> UINavigationController? {
        let storyboard = UIStoryboard(name: "NewsPage", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "NewsVC") as? NewsVC else { return nil }
        let navController = UINavigationController(rootViewController: vc)

        if let targetWindow = window {
            targetWindow.rootViewController = navController
            targetWindow.makeKeyAndVisible()
        } else if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let sceneDelegate = windowScene.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = navController
            sceneDelegate.window?.makeKeyAndVisible()
        }
        return navController
    }


    
    func showError(_ message: String) {
        PopUpVC.showErrorPopup(from: self, message: message)
    }
    
    func startLoading() {
        let blur = UIView(frame: view.bounds)
        blur.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        view.addSubview(blur)
        loading.startAnimating()
        
        blurView = blur
        view.isUserInteractionEnabled = false
    }

    func stopLoading() {
        blurView?.removeFromSuperview()
        loading.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == password{
            if string.isEmpty{ return true}
            
            /*let currentString: NSString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)*/
            let maxL = 9
            if let txt = textField.text {
                if txt.count > maxL{
                    return false
                }
            } else {
                return true
            }
        }
        
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@.")
        let charset = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: charset)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        email.resignFirstResponder()
        password.resignFirstResponder()
        return true
    }
    @IBAction func navToForgotVC(_ sender: Any) {
        let sb = UIStoryboard(name: "Authentication", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: "ForgotVC") as? ForgotVC{
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
}

