//
//  GameModeViewController.swift
//  myProject
//
//  Created by David Koch on 17.01.23.
//

import Foundation
import UIKit
import GoogleSignIn
import FirebaseCore
import FirebaseAuth

class GameModeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signOut(_ sender: Any) {
        GIDSignIn.sharedInstance.signOut()
        let firebaseAuth = Auth.auth()
        do{
            
            try firebaseAuth.signOut()
            //self.show(AuthenticationViewController(), sender: nil)
            
        } catch {
            showFailure(message: error.localizedDescription, title: "Error")
        }
    }
}
