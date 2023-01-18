//
//  Authentication.swift
//  myProject
//
//  Created by David Koch on 18.01.23.
//

import Foundation
import GoogleSignIn
import FirebaseAuth

class Authentication {
    
    
    
    func googleAuthLogin() {
        
        GIDSignIn.sharedInstance.signIn(withPresenting: AuthenticationViewController()) { result, error in
            
            guard error == nil else { return }
            
            guard let result = result else {
                return
            }
            //let userId = result.user.userID ?? ""
            let userIdToken = result.user.idToken?.tokenString ?? ""
            //let userFirstName = result.user.profile?.givenName ?? ""
            //let userLastName = result.user.profile?.familyName ?? ""
            //let userEmail = result.user.profile?.email ?? ""
            //let googleProfilePicURL = result.user.profile?.imageURL(withDimension: 150)?.absoluteString ?? ""
            let credential = GoogleAuthProvider.credential(withIDToken: userIdToken, accessToken: result.user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                AuthenticationViewController().performSegue(withIdentifier: "SignInSegue", sender: nil)
                
            }
            
        }
    }
}
