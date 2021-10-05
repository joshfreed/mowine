//
//  AnonymousUserPage.swift
//  AnonymousUserPage
//
//  Created by Josh Freed on 7/22/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import XCTest

class AnonymousUserPage {
    let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }

    func waitForExistence() {
        XCTAssertTrue(app.staticTexts["Get mo' out of mo' wine with a free account"].waitForExistence(timeout: .default))
    }

    func signUp() {
        app.buttons["Sign Up"].tap()
    }

    func logIn() {
        app.buttons["Log In"].tap()
    }
}
