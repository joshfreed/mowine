//
//  AddFriendCommandHandlerTests.swift
//  
//
//  Created by Josh Freed on 10/30/21.
//

import XCTest
import MoWine_Application
import MoWine_Domain
@testable import MoWine_Application_TestKit
@testable import MoWine_Domain_TestKit

class AddFriendCommandHandlerTests: XCTestCase {
    var sut: AddFriendCommandHandler!
    let session = MockSession()
    let userRepository = MockUserRepository()

    override func setUpWithError() throws {
        sut = AddFriendCommandHandler(session: session, userRepository: userRepository)
    }

    func test_addFriend_throws_error_if_no_current_user() async throws {
        do {
            try await sut.handle(command: AddFriendCommand(userId: "ABC"))
            XCTFail("Expected an error to be thrown")
        } catch SessionError.notLoggedIn {
            // Success!
        }
    }

    func test_addFriend_friend_is_added_to_repository() async throws {
        // Given
        let myUserId = UserId()
        let friendUserId = UserId()
        session.login(userId: myUserId)

        // When
        try await sut.handle(command: AddFriendCommand(userId: friendUserId.asString))

        // Then
        userRepository.verify_addFriend_wasCalled(owningUserId: myUserId, friendUserId: friendUserId)
    }
}
