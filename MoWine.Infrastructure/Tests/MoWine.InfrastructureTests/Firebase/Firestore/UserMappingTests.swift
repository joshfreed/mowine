//
//  UserTests.swift
//  mowine
//
//  Created by Josh Freed on 2019-04-12.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import XCTest
import Nimble
@testable import MoWine_Infrastructure
@testable import MoWine_Domain
@testable import MoWine_Domain_TestKit

class UserMappingTests: XCTestCase {
    var user = User(id: UserId(string: "111"), emailAddress: "test@test.com")

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Tests

    // MARK: toFirestore

    func test_toFirestore_defaults() {
        let output = user.toFirestore()
        expect(output["email"] as? String).to(equal("test@test.com"))
        expect(output["fullName"] as? String).to(equal(""))
    }

    func test_toFirestore_fullName() {
        user.fullName = "Barry Jones"
        let output = user.toFirestore()
        expect(output["fullName"] as? String).to(equal("Barry Jones"))
    }


    func test_toFirestore_profilePictureUrl() {
        user.profilePictureUrl = URL(string: "http://images.fakefakefake.com/path/to/image.png")
        let output = user.toFirestore()
        expect(output["photoURL"] as? String).to(equal("http://images.fakefakefake.com/path/to/image.png"))
    }
}
