//
//  AWSEmailAuthentication.swift
//  mowine
//
//  Created by Josh Freed on 3/23/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib
import AWSAuthCore
import AWSUserPoolsSignIn

class AWSEmailAuthenticationService: EmailAuthenticationService {
    lazy var pool = AWSCognitoUserPoolsSignInProvider.sharedInstance().getUserPool()
    
    func signIn(emailAddress: String, password: String, completion: @escaping (Result<Bool>) -> ()) {
        let user = pool.getUser(emailAddress)
        
        print("\(user)")
        user.getSession(emailAddress, password: password, validationData: nil).continueWith { task -> Any? in
            
            DispatchQueue.main.async {
                
                if let e = task.error {
                    let error = e as NSError
                    print("\(error)")
                    
                    let type = error.userInfo["__type"] as? String
                    
                    if type == "UserNotFoundException" || type == "NotAuthorizedException" {
                        completion(.success(false))
                    } else {
                        completion(.failure(error))
                    }
                } else {
                    completion(.success(true))
                }
                
            }
            
            return nil
        }
    }
    
    func signUp(user: User, password: String, completion: @escaping (EmptyResult) -> ()) {
        isEmailAddressAvailable(emailAddress: user.emailAddress) { result in
            switch result {
            case .success(let isAvailable):
                if isAvailable {
                    self.doSignUp(user: user, password: password, completion: completion)
                } else {
                    completion(.failure(EmailAuthenticationErrors.emailAddressAlreadyInUse))
                }
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    private func doSignUp(user: User, password: String, completion: @escaping (EmptyResult) -> ()) {
        var attributes = [AWSCognitoIdentityUserAttributeType]()
        
        let userIdAttr = AWSCognitoIdentityUserAttributeType()
        userIdAttr?.name = "custom:userId"
        userIdAttr?.value = user.id.description
        attributes.append(userIdAttr!)
        
        let firstNameAttr = AWSCognitoIdentityUserAttributeType()
        firstNameAttr?.name = "given_name"
        firstNameAttr?.value = user.firstName
        attributes.append(firstNameAttr!)
        
        let lastNameAttr = AWSCognitoIdentityUserAttributeType()
        lastNameAttr?.name = "family_name"
        lastNameAttr?.value = user.lastName
        attributes.append(lastNameAttr!)
        
        let emailAttr = AWSCognitoIdentityUserAttributeType()
        emailAttr?.name = "email"
        emailAttr?.value = user.emailAddress
        attributes.append(emailAttr!)
        
        // I'd like for the email address to be the username. But currently AWS Mobile Hub doesn't configure the user pool to make that
        // happen the way I'd like. It's set up to use email address as an alias, but that requires the actual username to NOT be the
        // email address. I'd love to change that, but I can't currently edit user pool configs created by AWS Mobile hub.
        // I could create a custom user pool, but it won't be in the hub, and I'd have to integrate its keys manually (blah I say)
        let username = user.id.description
        
        pool.signUp(username, password: password, userAttributes: attributes, validationData: nil).continueWith { task -> Any? in
            
            DispatchQueue.main.async {
                
                if let e = task.error {
                    let error = e as NSError
                    print("\(error)")
                    
                    let type = error.userInfo["__type"] as? String
                    let message = error.userInfo["message"] as? String
                    
                    if type == "InvalidPasswordException" {
                        completion(.failure(EmailAuthenticationErrors.invalidPassword(message: message)))
                    } else {
                        completion(.failure(error))
                    }
                } else {
                    completion(.success)
                }
                
            }
            
            return nil
        }
    }
    
    func isEmailAddressAvailable(emailAddress: String, completion: @escaping (Result<Bool>) -> ()) {
        
        // This is super hacky.
        // It's the best way I can think of to figure out whether an email address is already in use as an alias on AWS
        
        let user = pool.getUser(emailAddress)
        let password = "!@#$%^&*)08663471987avslkjhrRJvsjkaLJVDKCAEzIRIHVSINA#IN$@$$5ASVRGJNETfDGNHJ!@$@#$!@FGHMHMJU"
        
        user.getSession(emailAddress, password: password, validationData: nil).continueWith { task -> Any? in
            
            DispatchQueue.main.async {
                
                if let e = task.error {
                    let error = e as NSError
                    print("\(error)")
                    
                    let type = error.userInfo["__type"] as? String
        
                    if type == "UserNotFoundException" {
                        completion(.success(true))
                    } else if type == "NotAuthorizedException" {
                        completion(.success(false))
                    } else {
                        completion(.failure(error))
                    }
                } else {
                    completion(.success(false))
                }
                
            }
            
            return nil
        }
    }
}
