//
//  SceneDelegate.swift
//  myProject
//
//  Created by David Koch on 09.01.23.
//

import UIKit
import GoogleSignIn
import FirebaseAuth


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    let dataController = DataController(modelName: "myProject")
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        dataController.load()
        
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let auth = Auth.auth()
        
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            
            if user != nil || auth.currentUser != nil{
                let homePage = mainStoryboard.instantiateViewController(withIdentifier: "GameModeVC") as! GameModeViewController
                homePage.dataController = self.dataController
                
                self.window?.rootViewController?.show(homePage, sender: nil)
            } else {
                let authenticationViewController = mainStoryboard.instantiateViewController(withIdentifier: "AuthenticationVC") as! AuthenticationViewController
                authenticationViewController.dataController = self.dataController
                
                let navigationController = UINavigationController(rootViewController: authenticationViewController)
                navigationController.navigationBar.prefersLargeTitles = true
                navigationController.navigationBar.tintColor = .white
                self.window?.rootViewController = navigationController
            }
            
        }
        guard let _ = (scene as? UIWindowScene) else { return }
    }
}

