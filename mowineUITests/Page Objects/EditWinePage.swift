//
//  EditWinePage.swift
//  EditWinePage
//
//  Created by Josh Freed on 9/11/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import XCTest

class EditWinePage {
    private let app: XCUIApplication

    init(app: XCUIApplication) throws {
        self.app = app
        guard waitForExistence() else { throw PageErrors.wrongPage }
    }

    private func waitForExistence() -> Bool {
        app.navigationBars["Edit Wine"].waitForExistence(timeout: .default)
    }

    func setWineName(_ newName: String) {
        app.tables.textFields["Fancy Wine Name"].tap()
        app.tables.textFields["Fancy Wine Name"].clearAndEnterText(text: newName)
    }

    func updateRating(to value: Int) throws {
        let ratingPicker = try RatingPicker(el: app.tables.cells["Rating"])
        try ratingPicker.rate(value)
    }

    func changeType(to typeName: String) throws {
        _ = try tapType().selectType(typeName)
    }

    func changeVariety(to varietyName: String) throws {
        _ = try tapVariety().selectVariety(varietyName)
    }

    func tapType() throws -> SelectTypePage {
        app.tables.cells["Type"].children(matching: .other).element(boundBy: 0).children(matching: .other).element.tap()
        return try SelectTypePage(app: app)
    }

    func tapVariety() throws -> SelectVarietyPage {
        app.tables.cells["Variety"].children(matching: .other).element(boundBy: 0).tap()
        return try SelectVarietyPage(app: app)
    }

    func setLocation(_ location: String) {
        app.tables.textFields["Where did I find this wine?"].tap()
        app.tables.textFields["Where did I find this wine?"].typeText(location)
    }

    func setPrice(_ price: String) {
        app.tables.textFields["How much was this wine?"].tap()
        app.tables.textFields["How much was this wine?"].typeText(price)
    }

    func addPairing(_ pairing: String) {
        app.buttons["Add Pairing"].tap()

        let newTextField = app.tables.textFields.matching(.init(format: "placeholderValue = %@", "e.g. Sushi, Cheese, etc")).allElementsBoundByIndex.last!
        XCTAssertTrue(newTextField.waitForExistence(timeout: .default))

        newTextField.tap()
        newTextField.typeText(pairing)
        app.keyboards.buttons["Return"].tap()
    }

    func setNote(_ note: String) {
        let notesField = app.textViews["Notes"]
        notesField.tap()
        notesField.typeText(note)
    }

    func saveWine() throws -> MyCellarWineListPage {
        app.navigationBars["Edit Wine"].buttons["Save"].tap()
        return try MyCellarWineListPage(app: app)
    }

    func cancel() throws -> MyCellarWineListPage {
        app.navigationBars["Edit Wine"].buttons["Cancel"].tap()
        return try MyCellarWineListPage(app: app)
    }
}

struct SelectTypePage {
    private let app: XCUIApplication

    init(app: XCUIApplication) throws {
        self.app = app
    }

    func selectType(_ typeName: String) throws -> EditWinePage {
        app.tables.switches[typeName].tap()
        return try EditWinePage(app: app)
    }
}

struct SelectVarietyPage {
    private let app: XCUIApplication

    init(app: XCUIApplication) throws {
        self.app = app
    }

    func selectVariety(_ varietyName: String) throws -> EditWinePage {
        app.tables.switches[varietyName].tap()
        return try EditWinePage(app: app)
    }
}
