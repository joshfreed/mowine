//
//  UserProfilePage.swift
//  mowineUITests
//
//  Created by Josh Freed on 10/25/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import XCTest

class UserProfilePage {
    private let app: XCUIApplication
    private var header: XCUIElement { app.otherElements["User Profile Header"] }
    private var friendButton: XCUIElement { app.navigationBars.buttons["FriendButton"] }

    var name: String { header.staticTexts.firstMatch.label }
    var profilePicture: String { header.images.firstMatch.label }
    var friendButtonTitle: String { friendButton.label }

    init(app: XCUIApplication) throws {
        self.app = app

        print(app.debugDescription)
        guard header.waitForExistence(timeout: .default) else { throw PageErrors.wrongPage }
    }

    func goBack() throws -> FriendsPage {
        app.navigationBars.buttons.element(boundBy: 0).tap()
        return try FriendsPage(app: app)
    }

    func addFriend() throws -> UserProfilePage {
        friendButton.tap()
        return try UserProfilePage(app: app)
    }

    func removeFriend() throws -> RemoveFriendMenu {
        friendButton.tap()
        return try RemoveFriendMenu(app: app)
    }
}

struct RemoveFriendMenu {
    private let app: XCUIApplication

    private var sheet: XCUIElement { app.sheets["You are currently friends."] }
    private var confirmButton: XCUIElement { sheet.scrollViews.otherElements.buttons["Remove Friend"] }
    private var cancelButton: XCUIElement { sheet.scrollViews.otherElements.buttons["Cancel"] }

    init(app: XCUIApplication) throws {
        self.app = app
        guard sheet.waitForExistence(timeout: .default) else { throw PageErrors.wrongPage }
    }

    func confirm() throws -> UserProfilePage {
        confirmButton.tap()
        return try UserProfilePage(app: app)
    }

    func cancel() throws -> UserProfilePage {
        cancelButton.tap()
        return try UserProfilePage(app: app)
    }
}
