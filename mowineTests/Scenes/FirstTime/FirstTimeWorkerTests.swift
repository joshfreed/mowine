//
//  FirstTimeWorkerTests.swift
//  mowine
//
//  Created by Josh Freed on 3/29/18.
//  Copyright (c) 2018 Josh Freed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import mowine
import XCTest

class FirstTimeWorkerTests: XCTestCase {
    // MARK: Subject under test

    var sut: FirstTimeWorker!
    let facebookAuth = MockFacebookAuthService()
    let fbGraphApi = GraphApi()
    let userRepository = TestUserRepository()
    let session = MockSession()
    let googleAuth = MockGoogleAuthService()

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        setupFirstTimeWorker()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: Test setup

    func setupFirstTimeWorker() {
        sut = FirstTimeWorker(
            fbAuth: facebookAuth,
            fbGraphApi: fbGraphApi,
            userRepository: userRepository,
            session: session,
            googleAuth: googleAuth
        )
    }

    // MARK: Test doubles

    // MARK: Tests

    func testSomething() {
        // Given

        // When

        // Then
    }
}
