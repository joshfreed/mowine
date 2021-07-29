//
//  MoWineApp.swift
//  MoWineApp
//
//  Created by Josh Freed on 7/22/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import XCTest

class MoWineApp {
    let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }

    func waitForExistence() {
        XCTAssertTrue(app.tabBars["Tab Bar"].waitForExistence(timeout: 5))
    }

    func myAccountTab() {
        app.tabBars["Tab Bar"].buttons["My Account"].tap()
    }
}
