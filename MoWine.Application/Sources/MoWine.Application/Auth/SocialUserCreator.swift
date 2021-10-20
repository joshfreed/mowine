//
//  SocialSignInWorker.swift
//  mowine
//
//  Created by Josh Freed on 3/23/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import Foundation
import SwiftyBeaver
import MoWine_Domain

public class SocialUserCreator {
    let userRepository: UserRepository
    let session: Session

    public init(userRepository: UserRepository, session: Session) {
        self.userRepository = userRepository
        self.session = session
    }

    public func findOrCreateUserObjectForCurrentSession(from provider: SocialSignInProvider) async throws {
        guard let currentUserId = session.currentUserId else {
            throw SessionError.notLoggedIn
        }

        if try await userRepository.getUserById(currentUserId) != nil {
            return
        }

        try await fetchProfileAndCreateUser(provider: provider)
    }
    
    private func fetchProfileAndCreateUser(provider: SocialSignInProvider) async throws {
        let newUserInfo = try await provider.getNewUserInfo()
        try await createUser(newUserInfo, provider: provider)
    }
    
    private func createUser(_ newUserInfo: NewUserInfo, provider: SocialSignInProvider) async throws {
        guard let currentUserId = session.currentUserId else {
            throw SessionError.notLoggedIn
        }

        var user = User(id: currentUserId, emailAddress: newUserInfo.email)
        user.fullName = newUserInfo.firstName
        if let lastName = newUserInfo.lastName {
            user.fullName += " " + lastName
        }

        try await userRepository.add(user: user)

        try await setHigherResProfilePicture(user, provider: provider)
    }
    
    private func setHigherResProfilePicture(_ user: User, provider: SocialSignInProvider) async throws {
        guard let photoUrl = session.getPhotoUrl() else {
            return
        }

        let newUrlString = provider.getProfilePictureUrl(photoUrl.absoluteString)
        let highResUrl = URL(string: newUrlString)

        var _user = user
        _user.profilePictureUrl = highResUrl

        try await userRepository.save(user: _user)
    }
}
