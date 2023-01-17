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
                // Show the app's signed-out state.
                let homePage = mainStoryboard.instantiateViewController(withIdentifier: "AuthenticationVC") as! AuthenticationViewController
                
                //self.window?.rootViewController?.present(AuthenticationViewController(), animated: false)
                
            } else {
                let homePage = mainStoryboard.instantiateViewController(withIdentifier: "GameModeVC") as! GameModeViewController
                //self.window?.rootViewController?.present(GameModeViewController(), animated: false)
                // Show the app's signed-in state.
            }
        }
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    
    
}

