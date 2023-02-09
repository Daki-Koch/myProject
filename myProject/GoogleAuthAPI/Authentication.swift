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
    
    
    func googleAuthLogin(viewController: UIViewController, completion: @escaping (Bool, Error?) -> Void?) {
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            guard let result = result else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            let userIdToken = result.user.idToken?.tokenString ?? ""
            let credential = GoogleAuthProvider.credential(withIDToken: userIdToken, accessToken: result.user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            }
            
        }
    }
    
    func authLogin(email: String, password: String, completion: @escaping (Bool, Error?) -> Void?){
        let auth = Auth.auth()
        
        auth.signIn(withEmail: email, password: password) { authDataResult, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            if let _ = authDataResult?.user{
                completion(true, nil)
            }
        }
    }
    
    func signUp(email: String, username: String, password: String, completion: @escaping (Bool, Error?) -> Void?){
        let auth = Auth.auth()
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }

            if let authResult = authResult{
            
                if let userEmail = authResult.user.email{

                    auth.signIn(withEmail: userEmail, password: password) { result, error in
                        if let error = error {
                            DispatchQueue.main.async {
                                completion(false, error)
                            }
                            return
                        }
                        
                        if let _ = result?.user{
                            
                            let changeRequest = auth.currentUser?.createProfileChangeRequest()
                            changeRequest?.displayName = username
                            changeRequest?.commitChanges { error in
                                if let error = error {
                                    DispatchQueue.main.async {
                                        completion(false, error)
                                    }
                                    return
                                }
                            }
                            
                            DispatchQueue.main.async {
                                completion(true, nil)
                            }
                        }
                    }
                }
            }
        }
    }


}
