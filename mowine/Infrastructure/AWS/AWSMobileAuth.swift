//
//  AWSMobileAuth.swift
//  mowine
//
//  Created by Josh Freed on 11/14/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib
import AWSMobileClient
import SwiftyBeaver

class AWSMobileAuth {
    lazy var client: AWSMobileClient = AWSMobileClient.sharedInstance()
    
    func getIdentityId(completion: @escaping (EmptyResult) -> ()) {
        SwiftyBeaver.debug("getIdentityId")
        
        client.getIdentityId().continueWith { task in
            DispatchQueue.main.async {
                if let error = task.error {
                    completion(.failure(error))
                } else {
                    completion(.success)
                }
            }
            
            return nil
        }
    }
}

extension AWSMobileAuth: EmailAuthenticationService {
    func signIn(emailAddress: String, password: String, completion: @escaping (EmptyResult) -> ()) {
        client
            .signIn(username: emailAddress, password: password) { (signInResult, error) in
                DispatchQueue.main.async {
                    if let error = error as? AWSMobileClientError {
                        SwiftyBeaver.error("\(error)")
                        SwiftyBeaver.error("\(error.localizedDescription)")
                        completion(.failure(error))
                    } else if let error = error {
                        let nserror = error as NSError
                        let type = (nserror.userInfo["__type"] as? String) ?? ""
                        //let message = (nserror.userInfo["message"] as? String) ?? ""
                        SwiftyBeaver.error("\(error)")
                        SwiftyBeaver.error("\(error.localizedDescription)")
                        if type == "UserNotFoundException" {
                            completion(.failure(EmailAuthenticationErrors.userNotFound))
                        } else if type == "NotAuthorizedException" {
                            completion(.failure(EmailAuthenticationErrors.notAuthorized))
                        } else {
                            completion(.failure(error))
                        }
                    } else {
                        // Calling getIdentity on success because I try to access the identity right away in order to create a User object
                        // or to load wines for the current user. If I don't call getIdentityId then it's run in parallel by the AWS sign in
                        // code, so it becomes a race. If AWS getIdentityId does not finish in time then the app won't be able to operate
                        // So I call it here and force the completion to wait for the id
                        self.getIdentityId(completion: completion)
                    }
                }
            }
    }
    
    func signUp(emailAddress: String, password: String, completion: @escaping (EmptyResult) -> ()) {
        AWSMobileClient
            .sharedInstance()
            .signUp(username: emailAddress, password: password, userAttributes: ["email": emailAddress]) { signUpResult, error in
                DispatchQueue.main.async {
                    if signUpResult != nil {
                        SwiftyBeaver.info("User is signed up and confirmed.")
                        self.signIn(emailAddress: emailAddress, password: password, completion: completion)
                    } else if let error = error {
                        if let error = error as? AWSMobileClientError {
                            switch error {
                            case .usernameExists(let message):
                                SwiftyBeaver.error(message)
                                completion(.failure(EmailAuthenticationErrors.emailAddressAlreadyInUse))
                            case .invalidPassword(let message):
                                SwiftyBeaver.error(message)
                                completion(.failure(EmailAuthenticationErrors.invalidPassword(message: message)))
                            default:
                                SwiftyBeaver.error("\(error)")
                                SwiftyBeaver.error("\(error.localizedDescription)")
                                completion(.failure(error))
                            }
                        } else {
                            SwiftyBeaver.error("\(error)")
                            SwiftyBeaver.error("\(error.localizedDescription)")
                            completion(.failure(error))
                        }
                    }
                }
        } 
    }    
}

extension AWSMobileAuth: FacebookAuthenticationService {
    func linkFacebookAccount(token: String, completion: @escaping (EmptyResult) -> ()) {
        client.federatedSignIn(providerName: IdentityProvider.facebook.rawValue, token: token) { (userState, error) in
            if let error = error {
                SwiftyBeaver.error("Federated Sign In failed: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            } else {
                // Calling getIdentity on success because I try to access the identity right away in order to create a User object
                // But it doesn't seem to always populate in time. So this forces the rest of the app to wait for it
                DispatchQueue.main.async {
                    self.getIdentityId(completion: completion)
                }
            }
        }
    }
}
