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
        signUpPage.typeFullName("Test User1")
        signUpPage.typeEmailAddress("test1@jpfreed.com")
        signUpPage.typePassword("Testing123!")
        signUpPage.signUp()

        myAccount.waitForExistence()
        XCTAssertEqual("Test User1", myAccount.fullName)
        XCTAssertEqual("test1@jpfreed.com", myAccount.emailAddress)
        myAccount.tapSignOut()
        myAccount.confirmSignOut()

        anonymousUser.waitForExistence()
        anonymousUser.logIn()

        logInPage.waitForExistence()
        logInPage.typeEmailAddress("test1@jpfreed.com")
        logInPage.typePassword("Testing123!")
        logInPage.logIn()

        myAccount.waitForExistence()
        XCTAssertEqual("Test User1", myAccount.fullName)
        XCTAssertEqual("test1@jpfreed.com", myAccount.emailAddress)
    }
}
