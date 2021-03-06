//
//  FriendsService.swift
//  mowine
//
//  Created by Josh Freed on 2/26/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import SwiftyBeaver

public class FriendsService: ObservableObject {
    @Published public var friends: [Friend] = []

    private let session: Session
    private let userRepository: UserRepository
    private var cancellable: AnyCancellable?
    private var listener: MoWineListenerRegistration?

    public init(session: Session, userRepository: UserRepository) {
        self.session = session
        self.userRepository = userRepository
    }

    deinit {
        SwiftyBeaver.debug("deinit")
        listener?.remove()
        cancellable = nil
    }

    public func getMyFriends() {
        cancellable = session
            .currentUserIdPublisher
            .removeDuplicates()
            .compactMap { $0 }
            .sink { userId in
                self.updateListener(userId: userId)
            }
    }

    private func updateListener(userId: UserId) {
        listener?.remove()
        listener = userRepository.getFriendsOfAndListenForUpdates(userId: userId) { result in
            switch result {
            case .success(let friends):
                self.friends = friends.map {
                    Friend(id: $0.id.asString, name: $0.fullName, profilePictureUrl: $0.profilePictureUrl?.absoluteString ?? "")
                }
            case .failure(let error):
                SwiftyBeaver.error("\(error)")
            }
        }
    }

    public func isFriends(with userId: String) -> Bool {
        friends.contains { $0.id == userId }
    }

    public func addFriend(_ userId: String) {
        guard let currentUserId = session.currentUserId else { return }

        let newFriendId = UserId(string: userId)

        userRepository.addFriend(owningUserId: currentUserId, friendId: newFriendId) { result in

        }
    }
    
    public func removeFriend(_ userId: String) {
        guard let currentUserId = session.currentUserId else { return }

        let friendId = UserId(string: userId)

        userRepository.removeFriend(owningUserId: currentUserId, friendId: friendId) { result in

        }
    }
}

extension FriendsService {
    public struct Friend: Identifiable {
        public var id: String
        public var name: String
        public var profilePictureUrl: String

        public init(id: String, name: String, profilePictureUrl: String) {
            self.id = id
            self.name = name
            self.profilePictureUrl = profilePictureUrl
        }
    }
}
