//
//  UserProfileService.swift
//  mowine
//
//  Created by Josh Freed on 6/22/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import UIKit
import SwiftyBeaver
import Model
import Combine

class UserProfileService {
    let session: Session
    let userRepository: UserRepository
    let profilePictureWorker: ProfilePictureWorkerProtocol
    
    init(session: Session, userRepository: UserRepository, profilePictureWorker: ProfilePictureWorkerProtocol) {
        self.session = session
        self.userRepository = userRepository
        self.profilePictureWorker = profilePictureWorker
    }

    func updateProfilePicture(_ image: UIImage?) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                SwiftyBeaver.info("updateProfilePicture")

                if let newProfilePicture = image {
                    self.profilePictureWorker.setProfilePicture(image: newProfilePicture) { result in
                        switch result {
                        case .success: promise(.success(()))
                        case .failure(let error): promise(.failure(error))
                        }
                    }
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func updateEmailAddress(emailAddress: String) -> AnyPublisher<Void, Error> {
        SwiftyBeaver.info("updateEmailAddress (1)")

        guard let userId = self.session.currentUserId else {
            return Fail(error: SessionError.notLoggedIn).eraseToAnyPublisher()
        }

        return session
            .updateEmailAddress(emailAddress)
            .compactMap { [weak self] in self?.getUserById(userId) }
            .switchToLatest()
            .compactMap { [weak self] in self?.updateEmailAddress(user: $0, emailAddress: emailAddress) }
            .switchToLatest()
            .eraseToAnyPublisher()
    }

    private func updateEmailAddress(user: User, emailAddress: String) -> AnyPublisher<Void, Error> {
        SwiftyBeaver.info("updateEmailAddress (2)")
        
        if user.emailAddress == emailAddress {
            return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            var _user = user
            _user.emailAddress = emailAddress
            return save(user: _user)
        }
    }
    
    func updateUserProfile(_ request: UpdateUserProfileRequest) -> AnyPublisher<Void, Error> {
        SwiftyBeaver.info("updateUserProfile")
        
        guard let userId = session.currentUserId else {
            return Fail(error: SessionError.notLoggedIn).eraseToAnyPublisher()
        }
        
        return getUserById(userId)
            .compactMap { [weak self] user in self?.updateUserProfile(user: user, request: request) }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
    
    private func updateUserProfile(user: User, request: UpdateUserProfileRequest) -> AnyPublisher<Void, Error> {
        var _user = user
        _user.fullName = request.fullName
        return save(user: _user)
    }
    
    private func save(user: User) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { [weak self] promise in
                self?.userRepository.save(user: user) { result in
                    switch result {
                    case .success: promise(.success(()))
                    case .failure(let error): promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func getUserById(_ userId: UserId) -> AnyPublisher<User, Error> {
        Deferred {
            Future { [weak self] promise in
                self?.userRepository.getUserById(userId) { result in
                    switch result {
                    case .success(let user):
                        if let user = user {
                            promise(.success(user))
                        } else {
                            promise(.failure(UserRepositoryError.userNotFound))
                        }
                    case .failure(let error): promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

struct UpdateUserProfileRequest {
    let fullName: String
}
