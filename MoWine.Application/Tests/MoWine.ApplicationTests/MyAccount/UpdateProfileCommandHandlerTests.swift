//
//  UpdateProfileCommandHandlerTests.swift
//  
//
//  Created by Josh Freed on 10/3/21.
//

import XCTest
@testable import MoWine_Application
@testable import MoWine_Application_TestKit
@testable import MoWine_Domain_TestKit
import Nimble

class UpdateProfileCommandHandlerTests: XCTestCase {
    var sut: UpdateProfileCommandHandler!
    let session = MockSession()
    let userRepository = MockUserRepository()
    fileprivate let createProfilePicture = MockCreateProfilePictureCommandHandler()

    override func setUpWithError() throws {
        sut = UpdateProfileCommandHandler(
            session: session,
            userRepository: userRepository,
            createProfilePicture: createProfilePicture
        )
    }
}

fileprivate class MockCreateProfilePictureCommandHandler: CreateProfilePictureCommandHandler {
    init() {
        super.init(userImageStorage: MockUserImageStorage(), imageResizer: MockImageResizer(), userRepository: MockUserRepository())
    }
}
