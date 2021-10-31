//
//  RemoveFriend.swift
//  
//
//  Created by Josh Freed on 10/30/21.
//

import Foundation
import JFLib_Mediator
import MoWine_Domain

public struct RemoveFriendCommand: JFMCommand {
    public let userId: String

    public init(userId: String) {
        self.userId = userId
    }
}

public class RemoveFriendCommandHandler: BaseCommandHandler<RemoveFriendCommand> {
    private let session: Session
    private let userRepository: UserRepository

    public init(session: Session, userRepository: UserRepository) {
        self.session = session
        self.userRepository = userRepository
    }

    public override func handle(command: RemoveFriendCommand) async throws {
        guard let currentUserId = session.currentUserId else { throw SessionError.notLoggedIn }

        let friendId = UserId(string: command.userId)

        _ = try await userRepository.removeFriend(owningUserId: currentUserId, friendId: friendId)
    }
}
