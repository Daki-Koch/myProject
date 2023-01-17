//
//  AuthenticationHelpers.swift
//  myProject
//
//  Created by David Koch on 09.01.23.
//

import Foundation
import UIKit


extension UIViewController{
    
    func validateSignUpFields(_ email: String?, _ username: String?, _ password: String?, _ confirmPassword: String?) -> Bool {

        if let cleanedEmail = email?.trimmingCharacters(in: .whitespacesAndNewlines), let cleanedUsername = username?.trimmingCharacters(in: .whitespacesAndNewlines), let password = password, let confirmPassword = confirmPassword {
            
            
            if cleanedEmail == "" || cleanedUsername == "" || password == "" || confirmPassword == ""{
                showFailure(message: "Please fill in all fields", title: "Missing Data")
                return false
            }
            
            if UIViewController.isValidEmail(cleanedEmail){
                showFailure(message: "Please enter valid email", title: "Invalid email")
                return false
            }
            
            if UIViewController.isPasswordValid(password){
                showFailure(message: "Please make sure your password is at least 8 characters, contains a special character and a number.", title: "Invalid format")
                return false
            }
            
            if confirmPassword != password {
                showFailure(message: "Passwords are not matching. Make sure both passwords are identical.", title: "Invalid match")
                return false
            }
            
            return true
        }
        
        return false
        
    }

    func validateSignInFields(_ email: String?,_ password: String?) -> Bool{
        if let email = email, let password = password{
            if email == "" || password == ""{
                showFailure(message: "Please fill in all fields", title: "Missing Data")
                return false
            }
            return true
        }
        return false
    }
    static func isPasswordValid(_ password : String) -> Bool{
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[a-z])(?=.*[$@$#!%*?&'.,'])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func isValidEmail(_ email: String) -> Bool {
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return emailPred.evaluate(with: email)
    }
}
