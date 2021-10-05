//
//  MyCellarWineListPage.swift
//  MyCellarWineListPage
//
//  Created by Josh Freed on 9/11/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import XCTest

class MyCellarWineListPage {
    let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }

    func waitForExistence(wineTypes: String) {
        XCTAssertTrue(app.navigationBars[wineTypes].waitForExistence(timeout: .default))
    }

    func selectWine(at index: Int) {
        app.tables.cells.element(boundBy: index).tap()
    }

    func goBack() {
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }

    func assertContainsWine(named name: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(app.staticTexts[name].exists, file: file, line: line)
    }

    func assertDoesNotContainWine(named name: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertFalse(app.staticTexts[name].exists, file: file, line: line)
    }
}
