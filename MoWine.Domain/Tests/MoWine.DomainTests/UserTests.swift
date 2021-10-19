//
//  UserTests.swift
//  
//
//  Created by Josh Freed on 10/19/21.
//

import XCTest
@testable import MoWine_Domain

class UserTests: XCTestCase {
    func test_user_init() {
        let userId = UserId()
        let user = User(id: userId, emailAddress: "test@test.com")
        XCTAssertEqual(userId, user.id)
        XCTAssertEqual("test@test.com", user.emailAddress)
    }
}
