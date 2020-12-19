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
    
    func signUp(emailAddress: String, password: String, firstName: String, lastName: String?, completion: @escaping (Result<User, Error>) -> ()) {
        // TODO check password strength requirements?
        
        emailAuthService.signUp(emailAddress: emailAddress, password: password) { result in
            switch result {
            case .success: self.createUser(emailAddress: emailAddress, firstName: firstName, lastName: lastName, completion: completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }

    func createUser(emailAddress: String, firstName: String, lastName: String?, completion: @escaping (Result<User, Error>) -> ()) {
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
    
    func handleGetUserSuccess(newUser: User, existingUser: User?, completion: @escaping (Result<User, Error>) -> ()) {
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
    
    func saveNewUser(user: User, completion: @escaping (Result<Void, Error>) -> ()) {
        userRepository.add(user: user) { result in
            switch result {
            case .success: completion(.success(()))
            case .failure(let error): completion(.failure(error))
            }
        }
    }    
}