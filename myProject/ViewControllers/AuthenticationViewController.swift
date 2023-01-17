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
    var googleSignIn = GIDSignIn.sharedInstance
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
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
        }
    }
    
    @IBAction func googleSignIn(_ sender: UIButton!) {
        print("something")
        self.googleAuthLogin()
        
    }
    
    func googleAuthLogin() {
        
        print("pressed")
        let googleConfig = GIDConfiguration(clientID: "CLIENT_ID")
        
        self.googleSignIn.signIn(withPresenting: self) { result, error in
            
            guard error == nil else { return }
            
            guard let result = result else {
                return
            }
            let userId = result.user.userID ?? ""
            let userIdToken = result.user.idToken
            let userFirstName = result.user.profile?.givenName ?? ""
            let userLastName = result.user.profile?.familyName ?? ""
            let userEmail = result.user.profile?.email ?? ""
            let googleProfilePicURL = result.user.profile?.imageURL(withDimension: 150)?.absoluteString ?? ""
            
        }
    }
}



