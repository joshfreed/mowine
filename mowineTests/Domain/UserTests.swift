//
//  UserTests.swift
//  mowine
//
//  Created by Josh Freed on 2019-04-12.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import XCTest
@testable import mowine
import Nimble

class UserTests: XCTestCase {
    var user = User(emailAddress: "test@test.com")

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
        expect(output["firstName"]).to(beNil())
        expect(output["lastName"]).to(beNil())
    }

    func test_toFirestore_firstName() {
        user.firstName = "Barry"
        let output = user.toFirestore()
        expect(output["firstName"] as? String).to(equal("Barry"))
    }

    func test_toFirestore_lastName() {
        user.lastName = "Jones"
        let output = user.toFirestore()
        expect(output["lastName"] as? String).to(equal("Jones"))
    }

    func test_toFirestore_profilePictureUrl() {
        user.profilePictureUrl = URL(string: "http://images.fakefakefake.com/path/to/image.png")
        let output = user.toFirestore()
        expect(output["photoURL"] as? String).to(equal("http://images.fakefakefake.com/path/to/image.png"))
    }
}
