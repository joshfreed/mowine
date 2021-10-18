//
//  MyCellarPage.swift
//  MyCellarPage
//
//  Created by Josh Freed on 9/11/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import XCTest

class MyCellarPage {
    private let app: XCUIApplication

    init(app: XCUIApplication) throws {
        self.app = app
        guard waitForExistence() else { throw PageErrors.wrongPage }
    }

    private func waitForExistence() -> Bool {
        app.navigationBars["My Cellar"].waitForExistence(timeout: .default)
    }

    func showMyRedWines() throws -> MyCellarWineListPage {
        app.buttons["Show My Red Wines"].tap()
        return try MyCellarWineListPage(app: app)
    }

    func showMyWhiteWines() throws -> MyCellarWineListPage {
        app.buttons["Show My White Wines"].tap()
        return try MyCellarWineListPage(app: app)
    }
}
