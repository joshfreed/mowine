//
//  FinalizeWinePage.swift
//  mowineUITests
//
//  Created by Josh Freed on 10/18/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import XCTest

struct FinalizeWinePage {
    private let app: XCUIApplication

    init(app: XCUIApplication) throws {
        self.app = app
        guard app.navigationBars["Add Wine"].waitForExistence(timeout: .default) else { throw PageErrors.wrongPage }
    }

    func typeName(_ name: String) throws -> FinalizeWinePage {
        app.textFields["wineName"].tap()
        app.textFields["wineName"].typeText(name)
        return try FinalizeWinePage(app: app)
    }

    func rateWine(_ rating: Int) throws -> FinalizeWinePage {
        let ratingPicker = try RatingPicker(el: app.otherElements["Rating Picker"])
        try ratingPicker.rate(rating)
        return try FinalizeWinePage(app: app)
    }

    func submitCreateWine() throws -> MyCellarPage {
        app.buttons["createWineButton"].tap()
        return try MyCellarPage(app: app)
    }
}
