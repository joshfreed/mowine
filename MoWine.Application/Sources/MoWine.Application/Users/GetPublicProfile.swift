//
//  GetPublicProfile.swift
//  MoWine.Application
//
//  Created by Josh Freed on 11/1/21.
//

import Foundation
import JFLib_Mediator
import MoWine_Domain

public struct GetPublicProfileQuery: JFMQuery {
    public let userId: String

    public init(userId: String) {
        self.userId = userId
    }
}

public struct GetPublicProfileResponse {
    public let fullName: String
    public let profilePictureUrl: URL?

    public init(fullName: String, profilePictureUrl: URL?) {
        self.fullName = fullName
        self.profilePictureUrl = profilePictureUrl
    }
}

class GetPublicProfileQueryHandler: BaseQueryHandler<GetPublicProfileQuery, GetPublicProfileResponse> {
    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    override func handle(query: GetPublicProfileQuery) async throws -> GetPublicProfileResponse {
        let userId = UserId(string: query.userId)

        guard let user = try await userRepository.getUserById(userId) else { throw ApplicationErrors.userNotFound }

        return GetPublicProfileResponse(fullName: user.fullName, profilePictureUrl: user.profilePictureUrl)
    }
}
