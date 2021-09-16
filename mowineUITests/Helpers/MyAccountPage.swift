//
//  MyAccountPage.swift
//  MyAccountPage
//
//  Created by Josh Freed on 7/22/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import XCTest

class MyAccountPage {
    let app: XCUIApplication

    var fullName: String { app.staticTexts["fullName"].label }
    var emailAddress: String { app.staticTexts["emailAddress"].label }

    init(app: XCUIApplication) {
        self.app = app
    }

    func waitForExistence() {
        XCTAssertTrue(app.buttons["signOutButton"].waitForExistence(timeout: 5))
    }

    func tapSignOut() {
        app.buttons["signOutButton"].tap()
        XCTAssertTrue(app.sheets["Are you sure?"].waitForExistence(timeout: 5))
    }

    func confirmSignOut() {
        app.sheets["Are you sure?"].scrollViews.otherElements.buttons["Sign Out"].tap()
    }
}