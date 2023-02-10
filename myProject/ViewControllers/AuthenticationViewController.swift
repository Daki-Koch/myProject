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
    var dataController: DataController!
    
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        googleSignInButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(googleSignIn)))
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        activityIndicator.startAnimating()
        if validateSignInFields(emailTextField.text, passwordTextField.text){
            Authentication().authLogin(email: emailTextField.text!, password: passwordTextField.text!) { result, error in
                if let error = error{
                    self.showFailure(message: error.localizedDescription, title: "Error")
                    return
                }
                
                if result{
                    
                    self.performSegue(withIdentifier: "SignInSegue", sender: nil)
                    self.passwordTextField.text = ""
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    
    @objc func googleSignIn() {
        activityIndicator.startAnimating()
        Authentication().googleAuthLogin(viewController: self) { result, error in
            if let error = error{
                self.showFailure(message: error.localizedDescription, title: "Error")
                return
            }
            if result{
                self.performSegue(withIdentifier: "SignInSegue", sender: nil)
                self.activityIndicator.stopAnimating()
            }
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GameModeViewController{
            vc.dataController = dataController
        }

    }

}



