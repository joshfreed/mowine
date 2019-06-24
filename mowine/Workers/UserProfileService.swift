//
//  UserProfileService.swift
//  mowine
//
//  Created by Josh Freed on 6/22/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import Foundation
import PromiseKit

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
        return session.getCurrentUser().then { user in
            self.updateEmailAddress(user: user, emailAddress: emailAddress)
        }
    }
    
    private func updateEmailAddress(user: User, emailAddress: String) -> Promise<Void> {
        if user.emailAddress == emailAddress {
            return Promise()
        } else {
            var _user = user
            _user.emailAddress = emailAddress
            return save(user: _user)
        }
    }
    
    func updateUserProfile(_ request: UpdateUserProfileRequest) -> Promise<Void> {
        return session.getCurrentUser().then { user in
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
}

struct UpdateUserProfileRequest {
    let firstName: String?
    let lastName: String?
}
