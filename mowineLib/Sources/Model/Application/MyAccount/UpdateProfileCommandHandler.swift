//
//  UpdateProfileCommandHandler.swift
//  
//
//  Created by Josh Freed on 10/3/21.
//

import Foundation
import MoWine_Domain

public struct UpdateProfileCommand {
    public let email: String
    public let fullName: String
    public let image: Data?

    public init(email: String, fullName: String, image: Data?) {
        self.email = email
        self.fullName = fullName
        self.image = image
    }
}

public class UpdateProfileCommandHandler {
    private let session: Session
    private let userRepository: UserRepository
    private let createProfilePicture: CreateProfilePictureCommandHandler

    public init(session: Session, userRepository: UserRepository, createProfilePicture: CreateProfilePictureCommandHandler) {
        self.session = session
        self.userRepository = userRepository
        self.createProfilePicture = createProfilePicture
    }

    public func handle(_ command: UpdateProfileCommand) async throws {
        guard let userId = self.session.currentUserId else {
            throw SessionError.notLoggedIn
        }

        if let imageData = command.image {
            try await createProfilePicture.handle(.init(userId: userId.asString, data: imageData))
        }

        try await session.updateEmailAddress(command.email)

        guard var user = try await userRepository.getUserById(userId) else {
            throw ApplicationErrors.userNotFound
        }
        user.emailAddress = command.email
        user.fullName = command.fullName
        try await userRepository.save(user: user)
    }
}
