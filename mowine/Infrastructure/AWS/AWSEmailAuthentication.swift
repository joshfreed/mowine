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

class AWSEmailAuthenticationService: NSObject, EmailAuthenticationService {
    lazy var pool = AWSCognitoUserPoolsSignInProvider.sharedInstance().getUserPool()
    lazy var signInManager = AWSSignInManager.sharedInstance()
    lazy var userPoolsSignInProvider = AWSCognitoUserPoolsSignInProvider.sharedInstance()
    lazy var providerKey = userPoolsSignInProvider.identityProviderName
    
    private var passwordAuthenticationCompletion: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>?
    private var username: String?
    private var password: String?
    private var loginCompletion: ((EmptyResult) -> ())?
    
    override init() {
        super.init()
        userPoolsSignInProvider.setInteractiveAuthDelegate(self)
    }
    
    // MARK: - Sign In
    
    func signIn(emailAddress: String, password: String, completion: @escaping (EmptyResult) -> ()) {
        self.username = emailAddress
        self.password = password
        self.loginCompletion = completion

        login(with: providerKey, completion: completion)
    }
    
    func login(with providerKey: String, completion: @escaping (EmptyResult) -> ()) {
        signInManager.login(signInProviderKey: providerKey) { (result: Any?, error: Error?) in
            print("signInManager.login returned")
            DispatchQueue.main.async {
                let awsResult = AWSResult(result: result, error: error)
                self.handleLoginResult(result: awsResult, completion: completion)
            }
        }
    }
    
    private func handleLoginResult(result: AWSResult, completion: @escaping (EmptyResult) -> ()) {
        if result.isError {
            if result.errorType == "UserNotFoundException" {
                completion(.failure(EmailAuthenticationErrors.userNotFound))
            } else if result.errorType == "NotAuthorizedException" {
                completion(.failure(EmailAuthenticationErrors.notAuthorized))
            } else {
                completion(.failure(result.error!))
            }
        } else {
            completion(.success)
        }
    }
    
    // MARK: - Sign Up
    
    func signUp(emailAddress: String, password: String, completion: @escaping (EmptyResult) -> ()) {
        var attributes: [AWSCognitoIdentityUserAttributeType] = []
        
        let emailAttr = AWSCognitoIdentityUserAttributeType()
        emailAttr?.name = "email"
        emailAttr?.value = emailAddress
        attributes.append(emailAttr!)
        
        // I'd like for the email address to be the username. But currently AWS Mobile Hub doesn't configure the user pool to make that
        // happen the way I'd like. It's set up to use email address as an alias, but that requires the actual username to NOT be the
        // email address. I'd love to change that, but I can't currently edit user pool configs created by AWS Mobile hub.
        // I could create a custom user pool, but it won't be in the hub, and I'd have to integrate its keys manually (blah I say)
        let username = UUID().uuidString

        pool.signUp(username, password: password, userAttributes: attributes, validationData: nil).continueWith { task -> Any? in
            let awsResult = AWSResult(result: task.result, error: task.error)

            DispatchQueue.main.async {
                if awsResult.isError {
                    if awsResult.errorType == "InvalidPasswordException" {
                        completion(.failure(EmailAuthenticationErrors.invalidPassword(message: awsResult.errorMessage)))
                    } else {
                        completion(.failure(awsResult.error!))
                    }
                } else {
                    self.signIn(emailAddress: emailAddress, password: password, completion: completion)
                }
            }

            return nil
        }
    }

    private func handleSignUpResult(result: AWSResult, completion: @escaping (EmptyResult) -> ()) {
        if result.isError {
            if result.errorType == "InvalidPasswordException" {
                completion(.failure(EmailAuthenticationErrors.invalidPassword(message: result.errorMessage)))
            } else {
                completion(.failure(result.error!))
            }
        } else {
            completion(.success)
        }
    }
}

extension AWSEmailAuthenticationService: AWSCognitoIdentityInteractiveAuthenticationDelegate {
    func startPasswordAuthentication() -> AWSCognitoIdentityPasswordAuthentication {
        return self
    }
}

extension AWSEmailAuthenticationService: AWSCognitoUserPoolsSignInHandler {
    func handleUserPoolSignInFlowStart() {
        guard let username = username, let password = password else {
            return
        }
        
        passwordAuthenticationCompletion?.set(result: AWSCognitoIdentityPasswordAuthenticationDetails(username: username, password: password))
    }
}

extension AWSEmailAuthenticationService: AWSCognitoIdentityPasswordAuthentication {
    func didCompleteStepWithError(_ error: Error?) {
        guard let error = error else {
            return
        }
        print("didCompleteStepWithError \(error)")
        guard let loginCompletion = loginCompletion else {
            fatalError("No callback set for loginCompletion")
        }
        let awsResult = AWSResult(result: nil, error: error)
        DispatchQueue.main.async {
            self.handleLoginResult(result: awsResult, completion: loginCompletion)
            self.loginCompletion = nil
        }
    }
    
    func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {
        passwordAuthenticationCompletion = passwordAuthenticationCompletionSource
    }
}
