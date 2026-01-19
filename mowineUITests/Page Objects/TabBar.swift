//
//  MoWineApp.swift
//  MoWineApp
//
//  Created by Josh Freed on 7/22/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import XCTest

class TabBar {
    private let app: XCUIApplication
    private var tabBar: XCUIElement { app.tabBars["Tab Bar"] }

    init(app: XCUIApplication) throws {
        self.app = app
        guard tabBar.waitForExistence(timeout: .default) else { throw PageErrors.illegalState }
    }

    func selectMyCellarTab() throws -> MyCellarPage {
        tabBar.buttons["My Cellar"].tap()
        return try MyCellarPage(app: app)
    }

    func selectFriendsTab() throws -> FriendsPage {
        tabBar.buttons["Friends"].tap()
        return try FriendsPage(app: app)
    }

    func selectMyAccountTab() throws -> MyAccountPage {
        tabBar.buttons["My Account"].tap()
        return try MyAccountPage(app: app)
    }

    func selectMyAccountTabExpectingAnonymousUser() throws -> AnonymousUserPage {
        tabBar.buttons["My Account"].tap()
        return try AnonymousUserPage(app: app)
    }
}
