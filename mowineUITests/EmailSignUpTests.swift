//
//  EmailSignUpTests.swift
//  EmailSignUpTests
//
//  Created by Josh Freed on 7/22/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import XCTest

class EmailSignUpTests: XCTestCase {
    var mowine: MoWineApp!
    var anonymousUser: AnonymousUserPage!
    var signUpPage: SignUpPage!
    var myAccount: MyAccountPage!
    var logInPage: LogInPage!
    var fullName: String!
    var emailAddress: String!
    var password = "Testing123!"

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        let app = XCUIApplication()
        app.launchArguments.append("UI_TESTING")
        app.launch()

        mowine = MoWineApp(app: app)
        anonymousUser = AnonymousUserPage(app: app)
        signUpPage = SignUpPage(app: app)
        myAccount = MyAccountPage(app: app)
        logInPage = LogInPage(app: app)

        let num = Int.random(in: 1..<1000)
        fullName = "Test User\(num)"
        emailAddress = "test\(num)@jpfreed.com"
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSignUpByEmail() throws {
        mowine.waitForExistence()

        mowine.myAccountTab()

        anonymousUser.waitForExistence()
        anonymousUser.signUp()

        signUpPage.waitForExistence()
        signUpPage.typeFullName(fullName)
        signUpPage.typeEmailAddress(emailAddress)
        signUpPage.typePassword(password)
        signUpPage.signUp()

        myAccount.waitForExistence()
        XCTAssertEqual(fullName, myAccount.fullName)
        XCTAssertEqual(emailAddress, myAccount.emailAddress)
        myAccount.tapSignOut()
        myAccount.confirmSignOut()

        anonymousUser.waitForExistence()
        anonymousUser.logIn()

        logInPage.waitForExistence()
        logInPage.typeEmailAddress(emailAddress)
        logInPage.typePassword(password)
        logInPage.logIn()

        myAccount.waitForExistence()
        XCTAssertEqual(fullName, myAccount.fullName)
        XCTAssertEqual(emailAddress, myAccount.emailAddress)
    }
}
