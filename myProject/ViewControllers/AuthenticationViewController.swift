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
        googleSignInButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(googleSignIn)))
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        if validateSignInFields(emailTextField.text, passwordTextField.text){
            Authentication().authLogin(email: emailTextField.text!, password: passwordTextField.text!) { result, error in
                if let error = error{
                    self.showFailure(message: error.localizedDescription, title: "Error")
                    return
                }
                
                if result{
                    
                    self.performSegue(withIdentifier: "SignInSegue", sender: nil)
                    self.passwordTextField.text = ""
                }
            }
        }
    }
    
    
    @objc func googleSignIn() {
 
        Authentication().googleAuthLogin(viewController: self) { result, error in
            if let error = error{
                self.showFailure(message: error.localizedDescription, title: "Error")
                return
            }
            if result{
                self.performSegue(withIdentifier: "SignInSegue", sender: nil)
            }
        }
        
    }


}



