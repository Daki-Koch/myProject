//
//  SignUpViewController.swift
//  myProject
//
//  Created by David Koch on 09.01.23.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn


class SignUpViewController: UIViewController{
    
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        googleSignInButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(googleSignUp)))
        
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        // checks if sign up Fields are valid and filled.
        if validateSignUpFields(emailTextField.text, usernameTextField.text, passwordTextField.text, confirmPasswordTextField.text){
            //if valid and correctly filled, creates new user in firebase.
            Authentication().signUp(email: emailTextField.text!, username: usernameTextField.text!, password: passwordTextField.text!) { result, error in
                if let error = error{
                    self.showFailure(message: error.localizedDescription, title: "Error")
                    return
                }
                
                if result {
                    self.performSegue(withIdentifier: "SignUpSegue", sender: nil)
                }
            }
        }
    }
    
    
    @objc func googleSignUp() {
        
        Authentication().googleAuthLogin(viewController: self) { result, error in
            if let error = error{
                self.showFailure(message: error.localizedDescription, title: "Error")
                return
            }
            
            if result {
                self.performSegue(withIdentifier: "SignUpSegue", sender: nil)
            }
        }
        
    }
    
    
}
