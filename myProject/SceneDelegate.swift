//
//  SceneDelegate.swift
//  myProject
//
//  Created by David Koch on 09.01.23.
//

import UIKit
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                AuthenticationViewController.load()
            } else {
                let homePage = mainStoryboard.instantiateViewController(withIdentifier: "GameModeVC") as! GameModeViewController
                self.window?.rootViewController?.show(homePage, sender: nil)
            }
            
        }
        guard let _ = (scene as? UIWindowScene) else { return }
    }
}

