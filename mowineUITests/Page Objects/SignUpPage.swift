//
//  EmailSignUpPage.swift
//  EmailSignUpPage
//
//  Created by Josh Freed on 7/22/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import XCTest

class SignUpPage {
    let app: XCUIApplication

    init(app: XCUIApplication) throws {
        self.app = app
        guard waitForExistence() else { throw PageErrors.wrongPage }
    }

    private func waitForExistence() -> Bool {
        app.navigationBars["Sign Up"].waitForExistence(timeout: .default)
    }

    func typeFullName(_ text: String) throws -> SignUpPage {
        let textField = app.textFields["fullName"]
        textField.tap()
        textField.typeText(text)
        return try SignUpPage(app: app)
    }

    func typeEmailAddress(_ text: String) throws -> SignUpPage {
        let textField = app.textFields["email"]
        textField.tap()
        textField.typeText(text)
        return try SignUpPage(app: app)
    }

    func typePassword(_ text: String) throws -> SignUpPage {
        let textField = app.secureTextFields["password"]
        textField.tap()
        textField.typeText(text)
        return try SignUpPage(app: app)
    }

    func submitSignUp() throws -> MyAccountPage {
        app.otherElements.buttons["signUp"].tap()
        return try MyAccountPage(app: app)
    }
}
