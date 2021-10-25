//
//  FriendsPage.swift
//  mowineUITests
//
//  Created by Josh Freed on 10/23/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import XCTest

class FriendsPage {
    private let app: XCUIApplication
    private var searchField: XCUIElement { app.navigationBars["Friends"].searchFields["Search"] }

    var friendCount: Int { app.tables["My Friends List"].cells.count }

    init(app: XCUIApplication) throws {
        self.app = app

        guard app.navigationBars["Friends"].waitForExistence(timeout: .default) else { throw PageErrors.wrongPage }
    }

    func searchUsers(for searchText: String) throws -> UserSearchResultsPage {
        searchField.tap()
        searchField.typeText(searchText)
        return try UserSearchResultsPage(app: app)
    }

    func getFriend(name: String) throws -> MyFriendListItem {
        let el = app.tables["My Friends List"].cells["No Profile Picture, \(name)"]
        return try MyFriendListItem(el: el, app: app)
    }
}

class MyFriendListItem {
    private let el: XCUIElement
    private let app: XCUIApplication

    var name: String { el.staticTexts.firstMatch.label }
    var profilePictureLabel: String { el.images.firstMatch.label }

    init(el: XCUIElement, app: XCUIApplication) throws {
        self.el = el
        self.app = app
        print(app.debugDescription)
        guard el.exists else { throw PageErrors.illegalState }
    }

    func tap() throws -> UserProfilePage {
        el.tap()
        return try UserProfilePage(app: app)
    }
}
