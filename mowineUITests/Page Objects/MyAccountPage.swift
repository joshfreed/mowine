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

    var fullName: String { fullNameElement.label }
    var emailAddress: String { app.staticTexts["emailAddress"].label }

    private var fullNameElement: XCUIElement { app.staticTexts["fullName"] }
    private var signOutButton: XCUIElement { app.buttons["signOutButton"] }

    init(app: XCUIApplication) throws {
        self.app = app

        guard signOutButton.waitForExistence(timeout: .default) else { throw PageErrors.wrongPage }
        guard fullNameElement.waitForExistence(timeout: .default) else { throw PageErrors.wrongPage }
    }

    func signOut() throws -> SignOutMenu {
        signOutButton.tap()
        return try SignOutMenu(app: app)
    }
}

struct SignOutMenu {
    private let app: XCUIApplication

    private var sheet: XCUIElement { app.sheets["Are you sure?"] }
    private var confirmButton: XCUIElement { sheet.scrollViews.otherElements.buttons["Sign Out"] }

    init(app: XCUIApplication) throws {
        self.app = app
        guard sheet.waitForExistence(timeout: .default) else { throw PageErrors.wrongPage }
    }

    func confirmSignOut() throws -> AnonymousUserPage {
        confirmButton.tap()
        return try AnonymousUserPage(app: app)
    }
}
