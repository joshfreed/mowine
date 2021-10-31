//
//  GetMyFriends.swift
//  
//
//  Created by Josh Freed on 10/30/21.
//

import Foundation
import Combine
import SwiftyBeaver
import MoWine_Domain

public class GetMyFriendsQueryHandler {
    private let session: Session
    private let userRepository: UserRepository

    public init(session: Session, userRepository: UserRepository) {
        self.session = session
        self.userRepository = userRepository
    }

    public func subscribe() -> AnyPublisher<GetMyFriendsQueryResponse, Error> {
        SwiftyBeaver.verbose("subscribe: \(String(describing: session.currentUserId))")

        guard let userId = session.currentUserId else {
            return Just(GetMyFriendsQueryResponse(friends: [])).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        return userRepository.getFriends(userId: userId)
            .map { friends -> [GetMyFriendsQueryResponse.Friend] in
                friends.map {
                    .init(id: $0.id.asString, name: $0.fullName, profilePictureUrl: $0.profilePictureUrl)
                }
            }
            .map { friends in
                GetMyFriendsQueryResponse(friends: friends)
            }
            .eraseToAnyPublisher()
    }
}

public struct GetMyFriendsQueryResponse {
    public let friends: [Friend]

    public init(friends: [GetMyFriendsQueryResponse.Friend]) {
        self.friends = friends
    }

    public struct Friend: Identifiable, Equatable {
        public let id: String
        public let name: String
        public let profilePictureUrl: URL?

        public init(id: String, name: String, profilePictureUrl: URL? = nil) {
            self.id = id
            self.name = name
            self.profilePictureUrl = profilePictureUrl
        }
    }
}
