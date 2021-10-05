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

    init(app: XCUIApplication) {
        self.app = app
    }

    func waitForExistence() {
        XCTAssertTrue(app.navigationBars["Log In"].waitForExistence(timeout: .default))
    }

    func typeEmailAddress(_ text: String) {
        let textField = app.textFields["emailAddress"]
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

    func logIn() {
        app.otherElements.buttons["logIn"].tap()
    }
}
