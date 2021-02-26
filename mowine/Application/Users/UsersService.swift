//
// Created by Josh Freed on 2/26/21.
// Copyright (c) 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine

class UsersService: ObservableObject {
    private let session: Session
    private let userRepository: UserRepository

    init(session: Session, userRepository: UserRepository) {
        self.session = session
        self.userRepository = userRepository
    }

    func searchUsers(for searchString: String) -> AnyPublisher<[User], Error> {
        let currentUserId = session.currentUserId
        let publisher = PassthroughSubject<[User], Error>()
        userRepository.searchUsers(searchString: searchString) { result in
            switch result {
            case .success(let users):
                let usersWithoutCurrent = users.filter({ $0.id != currentUserId })
                publisher.send(usersWithoutCurrent)
            case .failure(let error):
                publisher.send(completion: .failure(error))
            }
        }
        return publisher.eraseToAnyPublisher()
    }
}

extension UsersService {
    struct UserSearchResult: Identifiable {
        var id: String
        var email: String
        var fullName: String
        var profilePictureUrl: String

        static func fromUser(_ user: User) -> UserSearchResult {
            UserSearchResult(
                id: user.id.asString,
                email: user.emailAddress,
                fullName: user.fullName,
                profilePictureUrl: user.profilePictureUrl?.absoluteString ?? ""
            )
        }
    }
}