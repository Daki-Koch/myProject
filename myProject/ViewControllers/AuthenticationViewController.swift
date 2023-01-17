//
//  AuthentificationViewController.swift
//  myProject
//
//  Created by David Koch on 09.01.23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseAuthUI
import GoogleSignIn


class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    fileprivate var _authHandle: AuthStateDidChangeListenerHandle!
    var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
            print(authDataResult)
        }
    }
    
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
            
            // If sign in succeeded, display the app's main content View.
        }
        
    }
    
}

