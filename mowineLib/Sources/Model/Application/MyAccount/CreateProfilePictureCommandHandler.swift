//
//  CreateProfilePictureCommandHandler.swift
//  
//
//  Created by Josh Freed on 10/3/21.
//

import Foundation
import CoreGraphics
import MoWine_Domain

public struct CreateProfilePictureCommand {
    let userId: String
    let data: Data
}

public class CreateProfilePictureCommandHandler {
    private let userImageStorage: UserImageStorage
    private let imageResizer: ImageResizer
    private let userRepository: UserRepository

    public init(userImageStorage: UserImageStorage, imageResizer: ImageResizer, userRepository: UserRepository) {
        self.userImageStorage = userImageStorage
        self.imageResizer = imageResizer
        self.userRepository = userRepository
    }

    public func handle(_ command: CreateProfilePictureCommand) async throws {
        let userId = UserId(string: command.userId)

        guard var user = try await userRepository.getUserById(userId) else {
            throw ApplicationErrors.userNotFound
        }

        let fullSize = CGSize(width: 400, height: 400)
        let fullData = try imageResizer.resize(data: command.data, to: fullSize)
        let url = try await userImageStorage.putImage(userId: userId, data: fullData)

        user.profilePictureUrl = url
        try await userRepository.save(user: user)
    }
}
