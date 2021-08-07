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

    public func searchUsers(for searchString: String) -> AnyPublisher<[User], Error> {
        let currentUserId = session.currentUserId
        let publisher = PassthroughSubject<[User], Error>()
        userRepository.searchUsers(searchString: searchString) { result in
            switch result {
            case .success(let users):
                let usersWithoutCurrent = users.filter({ $0.id != currentUserId })
                publisher.send(usersWithoutCurrent)
                publisher.send(completion: .finished)
            case .failure(let error):
                publisher.send(completion: .failure(error))
            }
        }
        return publisher.eraseToAnyPublisher()
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
        public var profilePictureUrl: String

        public static func fromUser(_ user: User) -> UserSearchResult {
            UserSearchResult(
                id: user.id.asString,
                email: user.emailAddress,
                fullName: user.fullName,
                profilePictureUrl: user.profilePictureUrl?.absoluteString ?? ""
            )
        }

        public init(id: String, email: String, fullName: String, profilePictureUrl: String) {
            self.id = id
            self.email = email
            self.fullName = fullName
            self.profilePictureUrl = profilePictureUrl
        }
    }
}
