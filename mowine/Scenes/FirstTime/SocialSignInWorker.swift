//
//  SocialSignInWorker.swift
//  mowine
//
//  Created by Josh Freed on 3/23/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import Foundation
import SwiftyBeaver

struct NewUserInfo {
    var email: String
    var firstName: String
    var lastName: String?
}

protocol SocialToken {}

protocol SocialSignInProvider {
    associatedtype Token: SocialToken
    func linkAccount(token: Token, completion: @escaping (Result<Void, Error>) -> ())
    func getNewUserInfo(completion: @escaping (Result<NewUserInfo, Error>) -> ())
    func getProfilePictureUrl(_ urlString: String) -> String
}

class SocialSignInWorker<T: SocialSignInProvider> {
    let userRepository: UserRepository
    let session: Session
    let provider: T
    
    init(userRepository: UserRepository, session: Session, provider: T) {
        self.userRepository = userRepository
        self.session = session
        self.provider = provider
    }
    
    func login(token: T.Token, completion: @escaping (Result<User, Error>) -> ()) {
        provider.linkAccount(token: token) { result in
            switch result {
            case .success: self.findOrCreateUserObjectForCurrentSession(completion: completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    private func findOrCreateUserObjectForCurrentSession(completion: @escaping (Result<User, Error>) -> ()) {
        guard let currentUserId = session.currentUserId else {
            completion(.failure(SessionError.notLoggedIn))
            return
        }
        
        userRepository.getUserById(currentUserId) { result in
            switch result {
            case .success(let user):
                if let user = user {
                    completion(.success(user))
                } else {
                    self.fetchProfileAndCreateUser(completion: completion)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchProfileAndCreateUser(completion: @escaping (Result<User, Error>) -> ()) {
        provider.getNewUserInfo { result in
            switch result {
            case .success(let newUserInfo): self.createUser(newUserInfo, completion: completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    private func createUser(_ newUserInfo: NewUserInfo, completion: @escaping (Result<User, Error>) -> ()) {
        guard let currentUserId = session.currentUserId else {
            completion(.failure(SessionError.notLoggedIn))
            return
        }
        
        var user = User(id: currentUserId, emailAddress: newUserInfo.email)
        user.firstName = newUserInfo.firstName
        user.lastName = newUserInfo.lastName
        
        userRepository.add(user: user) { result in
            switch result {
            case .success(let user): self.setHigherResProfilePicture(user, completion: completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    private func setHigherResProfilePicture(_ user: User, completion: @escaping (Result<User, Error>) -> ()) {
        guard let photoUrl = session.getPhotoUrl() else {
            completion(.success(user))
            return
        }
        
        let newUrlString = provider.getProfilePictureUrl(photoUrl.absoluteString)
        let highResUrl = URL(string: newUrlString)

        var _user = user
        _user.profilePictureUrl = highResUrl
        
        userRepository.save(user: _user) { result in
            switch result {
            case .success(let user): completion(.success(user))
            case .failure(let error): completion(.failure(error))
            }
        }        
    }
}
