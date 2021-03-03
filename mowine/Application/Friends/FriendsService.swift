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

class FriendsService: ObservableObject {
    @Published var friends: [Friend] = []

    private let session: Session
    private let userRepository: UserRepository
    private var cancellable: AnyCancellable?
    private var listener: MoWineListenerRegistration?

    init(session: Session, userRepository: UserRepository) {
        self.session = session
        self.userRepository = userRepository
    }

    deinit {
        SwiftyBeaver.debug("deinit")
        listener?.remove()
        cancellable = nil
    }

    func getMyFriends() {
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

    func isFriends(with userId: String) -> Bool {
        friends.contains { $0.id == userId }
    }

    func addFriend(_ userId: String) {
        guard let currentUserId = session.currentUserId else { return }

        let newFriendId = UserId(string: userId)

        userRepository.addFriend(owningUserId: currentUserId, friendId: newFriendId) { result in

        }
    }
    
    func removeFriend(_ userId: String) {
        
    }
}

extension FriendsService {
    struct Friend: Identifiable {
        var id: String
        var name: String
        var profilePictureUrl: String
    }
}
