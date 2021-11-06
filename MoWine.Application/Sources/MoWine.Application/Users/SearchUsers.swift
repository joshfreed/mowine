//
//  SearchUsers.swift
//  
//
//  Created by Josh Freed on 11/1/21.
//

import Foundation
import JFLib_Mediator
import MoWine_Domain

public struct SearchUsersQuery: JFMQuery {
    public let searchString: String

    public init(searchString: String) {
        self.searchString = searchString
    }
}

public struct SearchUsersResponse {
    public let users: [User]

    public init(users: [SearchUsersResponse.User]) {
        self.users = users
    }

    public struct User: Identifiable, Equatable {
        public var id: String
        public var email: String
        public var fullName: String
        public var profilePictureUrl: URL?

        public init(id: String, email: String, fullName: String, profilePictureUrl: URL?) {
            self.id = id
            self.email = email
            self.fullName = fullName
            self.profilePictureUrl = profilePictureUrl
        }
    }
}

class SearchUsersQueryHandler: BaseQueryHandler<SearchUsersQuery, SearchUsersResponse> {
    private let session: Session
    private let userRepository: UserRepository

    init(session: Session, userRepository: UserRepository) {
        self.session = session
        self.userRepository = userRepository
    }

    override func handle(query: SearchUsersQuery) async throws -> SearchUsersResponse {
        let users = try await userRepository
            .searchUsers(searchString: query.searchString)
            .filter { $0.id != session.currentUserId }

        let userDtos: [SearchUsersResponse.User] = users.map {
            .init(id: $0.id.asString, email: $0.emailAddress, fullName: $0.fullName, profilePictureUrl: $0.profilePictureUrl)
        }

        return .init(users: userDtos)
    }
}
