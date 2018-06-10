//
//  SignUpWorker.swift
//  mowine
//
//  Created by Josh Freed on 3/21/18.
//  Copyright (c) 2018 Josh Freed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import JFLib

class SignUpWorker {
    let emailAuthService: EmailAuthenticationService
    let userRepository: UserRepository
    let session: Session
    
    init(
        emailAuthService: EmailAuthenticationService,
        userRepository: UserRepository,
        session: Session
    ) {
        self.emailAuthService = emailAuthService
        self.userRepository = userRepository
        self.session = session
    }
    
    func signUp(emailAddress: String, password: String, completion: @escaping (EmptyResult) -> ()) {
        
        // Little hacky, but since my user pool is setup w/ username as the primary login and email as an attribute alias,
        // cognito will allow me to create even if the email address is already associated with an account
        // By signing in first I can see if this email address is already associated with an account
        
        emailAuthService.signIn(emailAddress: emailAddress, password: password) { result in
            switch result {
            case .success:
                // The user with this email address already exists AND this is the correct password!!
                // The user already has an account but is trying to sign up again
                completion(.success)
            case .failure(let error):
                switch error {
                case EmailAuthenticationErrors.userNotFound:
                    // This email address is not in use by another user account
                    // Let's sign them up!
                    self.emailAuthService.signUp(emailAddress: emailAddress, password: password, completion: completion)
                case EmailAuthenticationErrors.notAuthorized:
                    // This email address is already in use by another account and this password is not correct
                    // Assume that another user has signed up with this email address
                    completion(.failure(EmailAuthenticationErrors.emailAddressAlreadyInUse))
                default: completion(.failure(error))
                }
            }
        }
    }

    func createUser(emailAddress: String, firstName: String, lastName: String?, completion: @escaping (Result<User>) -> ()) {
        guard let currentUserId = session.currentUserId else {
            completion(.failure(SessionError.notLoggedIn))
            return
        }
        
        var user = User(id: currentUserId, emailAddress: emailAddress)
        user.firstName = firstName
        user.lastName = lastName
        
        userRepository.getUserById(currentUserId) { result in
            switch result {
            case .success(let existingUser): self.handleGetUserSuccess(newUser: user, existingUser: existingUser, completion: completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func handleGetUserSuccess(newUser: User, existingUser: User?, completion: @escaping (Result<User>) -> ()) {
        if let existingUser = existingUser {
            completion(.success(existingUser))
        } else {
            saveNewUser(user: newUser) { result in
                switch result {
                case .success: completion(.success(newUser))
                case .failure(let error): completion(.failure(error))
                }
            }
        }
    }
    
    func saveNewUser(user: User, completion: @escaping (EmptyResult) -> ()) {
        userRepository.saveUser(user: user) { result in
            switch result {
            case .success: completion(.success)
            case .failure(let error): completion(.failure(error))
            }
        }
    }    
}
