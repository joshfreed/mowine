//
//  UserProfileService.swift
//  mowine
//
//  Created by Josh Freed on 6/22/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyBeaver

class UserProfileService {
    let session: Session
    let userRepository: UserRepository
    let profilePictureWorker: ProfilePictureWorkerProtocol
    
    init(session: Session, userRepository: UserRepository, profilePictureWorker: ProfilePictureWorkerProtocol) {
        self.session = session
        self.userRepository = userRepository
        self.profilePictureWorker = profilePictureWorker
    }
    
    func updateProfilePicture(_ image: UIImage?) -> Promise<Void> {
        SwiftyBeaver.info("updateProfilePicture")
        
        if let newProfilePicture = image {
            return Promise<Void> { seal in
                self.profilePictureWorker.setProfilePicture(image: newProfilePicture) { result in
                    switch result {
                    case .success: seal.fulfill_()
                    case .failure(let error): seal.reject(error)
                    }
                }
            }
        } else {
            return Promise()
        }
    }
    
    func updateEmailAddress(emailAddress: String) -> Promise<Void> {
        SwiftyBeaver.info("updateEmailAddress (1)")
        
        guard let userId = session.currentUserId else {
            return Promise(error: SessionError.notLoggedIn)
        }
        
        return firstly {
            session.updateEmailAddress(emailAddress)
        }.then {
            self.getUserById(userId)
        }.then { user in
            self.updateEmailAddress(user: user, emailAddress: emailAddress)
        }
    }
    
    private func updateEmailAddress(user: User, emailAddress: String) -> Promise<Void> {
        SwiftyBeaver.info("updateEmailAddress (2)")
        
        if user.emailAddress == emailAddress {
            return Promise()
        } else {
            var _user = user
            _user.emailAddress = emailAddress
            return save(user: _user)
        }
    }
    
    func updateUserProfile(_ request: UpdateUserProfileRequest) -> Promise<Void> {
        SwiftyBeaver.info("updateUserProfile")
        
        guard let userId = session.currentUserId else {
            return Promise(error: SessionError.notLoggedIn)
        }
        
        return getUserById(userId).then { user in
            self.updateUserProfile(user: user, request: request)
        }
    }
    
    private func updateUserProfile(user: User, request: UpdateUserProfileRequest) -> Promise<Void> {
        var _user = user
        _user.firstName = request.firstName
        _user.lastName = request.lastName
        return save(user: _user)
    }
    
    private func save(user: User) -> Promise<Void> {        
        return Promise<Void> { seal in
            userRepository.save(user: user) { result in
                switch result {
                case .success: seal.fulfill_()
                case .failure(let error): seal.reject(error)
                }
            }
        }
    }
    
    private func getUserById(_ userId: UserId) -> Promise<User> {
        return Promise<User> { seal in
            userRepository.getUserById(userId) { result in
                switch result {
                case .success(let user):
                    if let user = user {
                        seal.fulfill(user)
                    } else {
                        seal.reject(UserRepositoryError.userNotFound)
                    }
                case .failure(let error): seal.reject(error)
                }
            }
        }
    }
}

struct UpdateUserProfileRequest {
    let firstName: String?
    let lastName: String?
}
