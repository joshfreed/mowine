//
//  LogInPage.swift
//  LogInPage
//
//  Created by Josh Freed on 7/22/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import XCTest

class LogInPage {
    let app: XCUIApplication

    init(app: XCUIApplication) throws {
        self.app = app
        guard waitForExistence() else { throw PageErrors.wrongPage }
    }

    private func waitForExistence() -> Bool {
        app.navigationBars["Log In"].waitForExistence(timeout: .default)
    }

    func typeEmailAddress(_ text: String) throws -> LogInPage {
        let textField = app.textFields["emailAddress"]
        textField.tap()
        textField.typeText(text)
        return try LogInPage(app: app)
    }

    func typePassword(_ text: String) throws -> LogInPage {
        let textField = app.secureTextFields["password"]
        textField.tap()
        textField.typeText(text)
        return try LogInPage(app: app)
    }

    func submitLogIn() throws -> MyAccountPage {
        app.otherElements.buttons["logIn"].tap()
        return try MyAccountPage(app: app)
    }
}
