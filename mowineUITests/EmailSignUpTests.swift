//
//  EmailSignUpTests.swift
//  EmailSignUpTests
//
//  Created by Josh Freed on 7/22/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import XCTest

class EmailSignUpTests: XCTestCase {
    var fullName: String!
    var emailAddress: String!
    var password = "Testing123!"

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        let app = XCUIApplication()
        app.launchArguments.append("UI_TESTING")
        app.launch()

        let num = Int.random(in: 1..<1000)
        fullName = "Test User\(num)"
        emailAddress = "test\(num)@jpfreed.com"
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSignUpByEmail() throws {
        let app = XCUIApplication()
        let tabBar = try TabBar(app: app)
        var myAccountPage: MyAccountPage

        myAccountPage = try tabBar
            .selectMyAccountTabExpectingAnonymousUser()
            .signUp()
            .typeFullName(fullName)
            .typeEmailAddress(emailAddress)
            .typePassword(password)
            .submitSignUp()

        XCTAssertEqual(fullName, myAccountPage.fullName)
        XCTAssertEqual(emailAddress, myAccountPage.emailAddress)

        myAccountPage = try myAccountPage
            .signOut()
            .confirmSignOut()
            .logIn()
            .typeEmailAddress(emailAddress)
            .typePassword(password)
            .submitLogIn()

        XCTAssertEqual(fullName, myAccountPage.fullName)
        XCTAssertEqual(emailAddress, myAccountPage.emailAddress)
    }
}
