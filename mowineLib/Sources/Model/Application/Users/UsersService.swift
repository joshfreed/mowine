//
// Created by Josh Freed on 2/26/21.
// Copyright (c) 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine

open class UsersService: ObservableObject {
    private let session: Session
    private let userRepository: UserRepository

    public init(session: Session, userRepository: UserRepository) {
        self.session = session
        self.userRepository = userRepository
    }

    public func searchUsers(for searchString: String) async throws -> [User] {
        var users = try await userRepository.searchUsers(searchString: searchString)
        users = users.filter { $0.id != session.currentUserId }
        return users
    }
    
    public func getUserById(_ id: String) async throws -> User {
        if let user = try await userRepository.getUserById(UserId(string: id)) {
            return user
        } else {
            throw UserRepositoryError.userNotFound
        }
    }
}

public extension UsersService {
    struct UserSearchResult: Identifiable, Equatable {
        public var id: String
        public var email: String
        public var fullName: String
        public var profilePictureUrl: URL?

        public static func fromUser(_ user: User) -> UserSearchResult {
            UserSearchResult(
                id: user.id.asString,
                email: user.emailAddress,
                fullName: user.fullName,
                profilePictureUrl: user.profilePictureUrl
            )
        }

        public init(id: String, email: String, fullName: String, profilePictureUrl: URL?) {
            self.id = id
            self.email = email
            self.fullName = fullName
            self.profilePictureUrl = profilePictureUrl
        }
    }
}
