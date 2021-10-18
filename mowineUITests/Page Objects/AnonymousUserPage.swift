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

    init(app: XCUIApplication) throws {
        self.app = app
        guard waitForExistence() else { throw PageErrors.wrongPage }
    }

    private func waitForExistence() -> Bool {
        app.staticTexts["Get mo' out of mo' wine with a free account"].waitForExistence(timeout: .default)
    }

    func signUp() throws -> SignUpPage {
        app.buttons["Sign Up"].tap()
        return try SignUpPage(app: app)
    }

    func logIn() throws -> LogInPage {
        app.buttons["Log In"].tap()
        return try LogInPage(app: app)
    }
}
