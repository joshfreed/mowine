//
//  AddFriend.swift
//  MoWine.Application
//
//  Created by Josh Freed on 10/30/21.
//

import Foundation
import JFLib_Mediator
import MoWine_Domain

public struct AddFriendCommand: JFMCommand {
    public let userId: String

    public init(userId: String) {
        self.userId = userId
    }
}

class AddFriendCommandHandler: BaseCommandHandler<AddFriendCommand> {
    private let session: Session
    private let userRepository: UserRepository

    init(session: Session, userRepository: UserRepository) {
        self.session = session
        self.userRepository = userRepository
    }

    override func handle(command: AddFriendCommand) async throws {
        guard let currentUserId = session.currentUserId else { throw SessionError.notLoggedIn }

        let newFriendId = UserId(string: command.userId)

        _ = try await userRepository.addFriend(owningUserId: currentUserId, friendId: newFriendId)
    }
}
