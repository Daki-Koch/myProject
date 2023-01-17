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


class SignUpViewController: UIViewController{
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        // checks if sign up Fields are valid and filled.
        if validateSignUpFields(emailTextField.text, usernameTextField.text, passwordTextField.text, confirmPasswordTextField.text){
            //if valid and correctly filled, creates new user in firebase.
            signUp(email: emailTextField.text!, username: usernameTextField.text!, password: passwordTextField.text!)
        }
    }
    
    func signUp(email: String, username: String, password: String){
        
        let auth = Auth.auth()
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.showFailure(message: error.localizedDescription, title: "Error")
                return
            }
            
            let db = Firestore.firestore()
            let userID: String = auth.currentUser!.uid
            db.collection("users").document(userID).setData(["email": email, "username": username]) { (err) in
                if let error = err{
                    self.showFailure(message: error.localizedDescription, title: "Error")
                }
            }
            
        }
    }

    
}
