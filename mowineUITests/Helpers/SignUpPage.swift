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

    init(app: XCUIApplication) {
        self.app = app
    }

    func waitForExistence() {
        XCTAssertTrue(app.navigationBars["Sign Up"].waitForExistence(timeout: .default))
    }

    func typeFullName(_ text: String) {
        let textField = app.textFields["fullName"]
        XCTAssertTrue(textField.exists)
        textField.tap()
        textField.typeText(text)
    }

    func typeEmailAddress(_ text: String) {
        let textField = app.textFields["email"]
        XCTAssertTrue(textField.exists)
        textField.tap()
        textField.typeText(text)
    }

    func typePassword(_ text: String) {
        let textField = app.secureTextFields["password"]
        XCTAssertTrue(textField.exists)
        textField.tap()
        textField.typeText(text)
    }

    func signUp() {
        app.otherElements.buttons["signUp"].tap()
    }
}
