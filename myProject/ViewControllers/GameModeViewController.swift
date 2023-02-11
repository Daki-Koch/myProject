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
    
    var dataController: DataController!
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    
    @IBOutlet weak var threePlayerButton: UIButton!
    @IBOutlet weak var fourPlayerButton: UIButton!
    @IBOutlet weak var fivePlayerButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    

    
    @IBAction func signOut(_ sender: Any) {
        GIDSignIn.sharedInstance.signOut()
        let firebaseAuth = Auth.auth()
        do{
            
            try firebaseAuth.signOut()
            if let navigationController = navigationController {
                navigationController.popToRootViewController(animated: true)
            }
            
            
        } catch {
            showFailure(message: error.localizedDescription, title: "Error")
        }
    }
    
    @IBAction func numberOfPlayerSelected(_ sender: UIButton) {
        
        performSegue(withIdentifier: "playerNameInputSegue", sender: sender.tag)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PlayerInputViewController{
            if let tag = sender.self as? Int{
                vc.numberOfPlayers = tag
                vc.dataController = dataController
            }
        }
        if let vc = segue.destination as? MapViewController{
            vc.dataController = dataController
        }
        
    }
    
}
