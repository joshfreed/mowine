//
//  SocialSignInWorker.swift
//  mowine
//
//  Created by Josh Freed on 3/23/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import Foundation
import SwiftyBeaver

public class SocialUserCreator {
    let userRepository: UserRepository
    let session: Session
    let provider: SocialSignInProvider
    let socialAuthService: SocialAuthService
    
    public init(userRepository: UserRepository, session: Session, provider: SocialSignInProvider) {
        self.userRepository = userRepository
        self.session = session
        self.provider = provider
        self.socialAuthService = socialAuthService
    }

    func findOrCreateUserObjectForCurrentSession() async throws {
        guard let currentUserId = session.currentUserId else {
            throw SessionError.notLoggedIn
        }

        if try await userRepository.getUserById(currentUserId) != nil {
            return
        }

        try await fetchProfileAndCreateUser()
    }
    
    private func fetchProfileAndCreateUser() async throws {
        let newUserInfo = try await provider.getNewUserInfo()
        try await createUser(newUserInfo)
    }
    
    private func createUser(_ newUserInfo: NewUserInfo) async throws {
        guard let currentUserId = session.currentUserId else {
            throw SessionError.notLoggedIn
        }

        var user = User(id: currentUserId, emailAddress: newUserInfo.email)
        user.fullName = newUserInfo.firstName
        if let lastName = newUserInfo.lastName {
            user.fullName += " " + lastName
        }

        try await userRepository.add(user: user)

        try await setHigherResProfilePicture(user)
    }
    
    private func setHigherResProfilePicture(_ user: User) async throws {
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
