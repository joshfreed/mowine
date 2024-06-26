//
//  MyFriends.swift
//  mowine
//
//  Created by Josh Freed on 10/30/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import JFLib_Services
import JFLib_Mediator
import MoWine_Application

class MyFriends: ObservableObject {
    @Published public private(set) var friends: [GetMyFriendsQueryResponse.Friend] = []

    @Injected private var session: Session
    @Injected private var getMyFriends: GetMyFriendsQueryHandler
    @Injected private var mediator: Mediator

    private var cancellable: AnyCancellable?

    func load() {
        guard cancellable == nil else { return }

        cancellable = session
            .currentUserIdPublisher
            .removeDuplicates()
            .compactMap { [weak self] _ in self?.getMyFriends.subscribe() }
            .switchToLatest()
            .replaceError(with: GetMyFriendsQueryResponse(friends: []))
            .receive(on: RunLoop.main)
            .print("MyFriends")
            .sink { [weak self] response in self?.present(response) }
    }

    func isFriends(with userId: String) -> Bool {
        friends.contains { $0.id == userId }
    }

    func addFriend(_ userId: String) async throws {
        try await mediator.send(AddFriendCommand(userId: userId))
    }

    func removeFriend(_ userId: String) async throws {
        try await mediator.send(RemoveFriendCommand(userId: userId))
    }
}

// MARK: Presentation

extension MyFriends {
    func present(_ response: GetMyFriendsQueryResponse) {
        friends = response.friends
    }
}

// MARK: Fakes

extension MyFriends {
    static func fake() -> MyFriends {
        let myFriends = MyFriends()

        myFriends.friends = [
            .init(id: "1", name: "Barry Jones", profilePictureUrl: nil),
            .init(id: "2", name: "Mark Buffalo", profilePictureUrl: nil),
            .init(id: "3", name: "Hanky Panky", profilePictureUrl: nil),
        ]

        return myFriends
    }
}
