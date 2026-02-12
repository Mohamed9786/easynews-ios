//
//  SceneDelegate.swift
//  EasyNews
//
//  Created by Mohamed Ali on 19/01/26.
//

import UIKit
import FirebaseInAppMessaging
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let authsb = UIStoryboard(name: "Authentication", bundle: nil)
        let newssb = UIStoryboard(name: "NewsPage", bundle: nil)
        
        let user = SecureVault.shared.getUser()
        if user.session{
            let newsVC = newssb.instantiateViewController(withIdentifier: "NewsVC")
            let vc = UINavigationController(rootViewController: newsVC)
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            vc.navigationBar.standardAppearance = appearance
            vc.navigationBar.scrollEdgeAppearance = appearance
            vc.navigationBar.barStyle = .black
            window.rootViewController = vc
        } else {
            let loginVC = authsb.instantiateViewController(withIdentifier: "LoginVC")
            let vc = UINavigationController(rootViewController: loginVC)
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            vc.navigationBar.standardAppearance = appearance
            vc.navigationBar.scrollEdgeAppearance = appearance
            vc.navigationBar.barStyle = .black
            window.rootViewController = vc
        }
        
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

