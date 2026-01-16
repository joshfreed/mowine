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

    private var editForm: XCUIElementQuery { app.collectionViews }
    private var wineNameTextField: XCUIElement { editForm.textFields["WineName"] }

    init(app: XCUIApplication) throws {
        self.app = app
        guard waitForExistence() else { throw PageErrors.wrongPage }
    }

    private func waitForExistence() -> Bool {
        app.navigationBars["Edit Wine"].waitForExistence(timeout: .default)
    }

    func setWineName(_ newName: String) {        
        wineNameTextField.tap()
        wineNameTextField.clearAndEnterText(text: newName)
    }

    func updateRating(to value: Int) throws {
        let ratingPicker = try RatingPicker(el: editForm.otherElements["Rating Picker"])
        try ratingPicker.rate(value)
    }

    func changeType(to typeName: String) throws {
        _ = try tapType().selectType(typeName)
    }

    func changeVariety(to varietyName: String) throws {
        _ = try tapVariety().selectVariety(varietyName)
    }

    func tapType() throws -> SelectTypePage {
        //editForm.cells["Type"].children(matching: .other).element(boundBy: 0).children(matching: .other).element.tap()
        editForm.buttons["TypePicker"].tap()
        return try SelectTypePage(app: app)
    }

    func tapVariety() throws -> SelectVarietyPage {
        editForm.buttons["VarietyPicker"].tap()
        return try SelectVarietyPage(app: app)
    }

    func setLocation(_ location: String) {
        editForm.textFields["Where did I find this wine?"].tap()
        editForm.textFields["Where did I find this wine?"].typeText(location)
    }

    func setPrice(_ price: String) {
        editForm.textFields["How much was this wine?"].tap()
        editForm.textFields["How much was this wine?"].typeText(price)
    }

    func addPairing(_ pairing: String) {
        guard app.buttons["Add Pairing"].isHittable else {
            return
        }

        app.buttons["Add Pairing"].tap()

        // Get last text field matching this placeholder
        // Can't just use editField.textFields["e.g. Sushi, Cheese, etc"] b/c that will return all, even those with a
        // value type in already. I just want the new, blank field added after pressing "Add Pairing".
        let newTextField = editForm.textFields
            .matching(.init(format: "placeholderValue = %@", "e.g. Sushi, Cheese, etc"))
            .allElementsBoundByIndex
            .last!
        
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
        app.collectionViews.buttons[typeName].tap()
        return try EditWinePage(app: app)
    }
}

struct SelectVarietyPage {
    private let app: XCUIApplication

    init(app: XCUIApplication) throws {
        self.app = app
    }

    func selectVariety(_ varietyName: String) throws -> EditWinePage {
        app.collectionViews.buttons[varietyName].tap()
        return try EditWinePage(app: app)
    }
}
