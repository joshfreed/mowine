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

class UserProfileService {
    let session: Session
    let userRepository: UserRepository
    let profilePictureWorker: ProfilePictureWorkerProtocol
    
    init(session: Session, userRepository: UserRepository, profilePictureWorker: ProfilePictureWorkerProtocol) {
        self.session = session
        self.userRepository = userRepository
        self.profilePictureWorker = profilePictureWorker
    }

    func updateProfilePicture(_ image: UIImage) async throws {
        SwiftyBeaver.info("updateProfilePicture")
        try await profilePictureWorker.setProfilePicture(image: image)
    }

    func updateEmailAddress(emailAddress: String) async throws {
        SwiftyBeaver.info("updateEmailAddress")

        guard let userId = self.session.currentUserId else {
            throw SessionError.notLoggedIn
        }

        guard let user = try await userRepository.getUserById(userId) else {
            throw UserRepositoryError.userNotFound
        }

        try await session.updateEmailAddress(emailAddress)

        if user.emailAddress != emailAddress {
            var _user = user
            _user.emailAddress = emailAddress
            try await userRepository.save(user: _user)
        }
    }

    func updateUserProfile(_ request: UpdateUserProfileRequest) async throws {
        SwiftyBeaver.info("updateUserProfile")

        guard let userId = session.currentUserId else {
            throw SessionError.notLoggedIn
        }

        guard let user = try await userRepository.getUserById(userId) else {
            throw UserRepositoryError.userNotFound
        }

        var _user = user
        _user.fullName = request.fullName
        try await userRepository.save(user: _user)
    }
}

struct UpdateUserProfileRequest {
    let fullName: String
}
