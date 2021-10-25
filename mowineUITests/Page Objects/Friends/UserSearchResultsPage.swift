//
//  UserSearchResultsPage.swift
//  mowineUITests
//
//  Created by Josh Freed on 10/23/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import XCTest

class UserSearchResultsPage {
    private let app: XCUIApplication
    private var navigationBar: XCUIElement { app.navigationBars["Friends"] }
    private var searchField: XCUIElement { navigationBar.searchFields["Search"] }
    private var cancelButton: XCUIElement { navigationBar.buttons["Cancel"] }

    init(app: XCUIApplication) throws {
        self.app = app

        guard searchField.waitForExistence(timeout: .default) else { throw PageErrors.wrongPage }
    }

    func addFriend(_ name: String) throws -> UserSearchResultsPage {
        app.tables["SearchResults"].cells.otherElements["SearchResult - \(name)"].buttons["MiniAddFriendButton"].tap()
        return try UserSearchResultsPage(app: app)
    }

    func addFriendButtonExists(for name: String) -> Bool {
        app.tables["SearchResults"].cells.otherElements["SearchResult - \(name)"].buttons["MiniAddFriendButton"].exists
    }

    func cancelSearch() throws -> FriendsPage {
        cancelButton.tap()
        return try FriendsPage(app: app)
    }
}
