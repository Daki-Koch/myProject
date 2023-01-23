//
//  PlayerInputViewController.swift
//  myProject
//
//  Created by David Koch on 20.01.23.
//

import Foundation
import UIKit
import GoogleSignIn
import FirebaseAuth

class PlayerInputViewController: UIViewController {
    
    var numberOfPlayers: Int!
    
    @IBOutlet weak var firstPlayerTextField: UITextField!
    @IBOutlet weak var secondPlayerTextField: UITextField!
    @IBOutlet weak var thirdPlayerTextField: UITextField!
    @IBOutlet weak var fourthPlayerTextField: UITextField!
    @IBOutlet weak var fifthPlayerTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let numberOfPlayers = numberOfPlayers{
            configureTextFields(numberOfPlayers: numberOfPlayers)
        }
        
    }
    
    @IBAction func savePlayerInputTapped(_ sender: Any) {
        var usernameTextFields: [UITextField] = [firstPlayerTextField, secondPlayerTextField, thirdPlayerTextField]
        
        if numberOfPlayers >= 4 {
            usernameTextFields.append(fourthPlayerTextField)
            
            
        }
        if numberOfPlayers == 5{
            usernameTextFields.append(fifthPlayerTextField)
        }
        
        validateUsernamesInputs(usernameTextFields: usernameTextFields)
        performSegue(withIdentifier: "ScoreSegue", sender: nil)
    }
    
    func configureTextFields(numberOfPlayers: Int){
        
        let auth = Auth.auth()
        if let username = auth.currentUser?.displayName{
            firstPlayerTextField.text = username
        }
    
        if numberOfPlayers == 3 {
            
            self.fifthPlayerTextField.isHidden = true
            self.fourthPlayerTextField.isHidden = true
        }
        if numberOfPlayers == 4 {
            
            self.fifthPlayerTextField.isHidden = true
        }
    }
    
    func validateUsernamesInputs(usernameTextFields: [UITextField]){
        for usernameTextField in usernameTextFields {
            if usernameTextField.text == "" {
                showFailure(message: "Missing username for Player \(usernameTextField.tag)", title: "Missing Data")
                return
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var usernames: [String] = [firstPlayerTextField.text!, secondPlayerTextField.text!, thirdPlayerTextField.text!]
        
        if numberOfPlayers >= 4 {
            usernames.append(fourthPlayerTextField.text!)
            
            
        }
        if numberOfPlayers == 5{
            usernames.append(fifthPlayerTextField.text!)
        }
        
        if let vc = segue.destination as? ScoreViewController{
            vc.players = []
            for username in usernames {
                
                vc.players.append(Player(name: username))
            }
            
        }
        
    }
}
