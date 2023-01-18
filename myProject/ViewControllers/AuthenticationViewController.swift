//
//  AuthentificationViewController.swift
//  myProject
//
//  Created by David Koch on 09.01.23.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn


class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(googleSignInButton)
        googleSignInButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(googleSignIn)))
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        if validateSignInFields(emailTextField.text, passwordTextField.text){
            signIn(email: emailTextField.text!, password: passwordTextField.text!)
        }
    }
    
    func signIn(email: String, password: String){
        let auth = Auth.auth()
        
        auth.signIn(withEmail: email, password: password) { authDataResult, error in
            if let error = error {
                self.showFailure(message: error.localizedDescription, title: "Error")
            }
        }
    }
    
    @objc func googleSignIn() {
 
        Authentication().googleAuthLogin()
        
    }
    

}



