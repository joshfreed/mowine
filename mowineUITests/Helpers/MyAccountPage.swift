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
        app/*@START_MENU_TOKEN@*/.buttons["signOutButton"]/*[[".buttons[\"Sign Out\"]",".buttons[\"signOutButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertTrue(app.sheets["Are you sure?"].waitForExistence(timeout: 5))
    }

    func confirmSignOut() {
        app.sheets["Are you sure?"].scrollViews.otherElements.buttons["Sign Out"].tap()
    }
}
