//
//  EditWinePage.swift
//  EditWinePage
//
//  Created by Josh Freed on 9/11/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import XCTest

class EditWinePage {
    let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }

    func waitForExistence() {
        XCTAssertTrue(app.navigationBars["Edit Wine"].waitForExistence(timeout: .default))
    }

    func setWineName(_ newName: String) {
        app.tables.textFields["Fancy Wine Name"].tap()
        app.tables.textFields["Fancy Wine Name"].clearAndEnterText(text: newName)
    }

    func updateRating(to value: Int) {
        app.tables.cells["Rating"].otherElements["Rating_\(value)"].tap()
    }

    func changeType(to typeName: String) {
        app.tables.cells["Type"].children(matching: .other).element(boundBy: 0).children(matching: .other).element.tap()
        XCTAssertTrue(app.tables.switches[typeName].waitForExistence(timeout: .default))
        app.tables.switches[typeName].tap()
        waitForExistence()
    }

    func changeVariety(to varietyName: String) {
        app.tables.cells["Variety"].children(matching: .other).element(boundBy: 0).tap()
        XCTAssertTrue(app.tables.switches[varietyName].waitForExistence(timeout: .default))
        app.tables.switches[varietyName].tap()
        waitForExistence()
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
        app.tables.cells["Add Pairing"].children(matching: .other).element(boundBy: 0).children(matching: .other).element.tap()

        let newTextField = app.tables.textFields.matching(.init(format: "placeholderValue = %@", "e.g. Sushi, Cheese, etc")).allElementsBoundByIndex.last!
        XCTAssertTrue(newTextField.waitForExistence(timeout: .default))

        newTextField.tap()
        newTextField.typeText(pairing)
        app.keyboards.buttons["Return"].tap()
    }

    func setNote(_ note: String) {
        let notesField = app.textViews["Notes"] // app.tables.children(matching: .cell).element(boundBy: 8).children(matching: .other).element(boundBy: 2).children(matching: .other).element.children(matching: .textView).element
        notesField.tap()
        notesField.typeText(note)
    }

    func saveWine() {
        app.navigationBars["Edit Wine"].buttons["Save"].tap()
    }

    func cancel() {
        app.navigationBars["Edit Wine"].buttons["Cancel"].tap()
    }
}
