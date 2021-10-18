//
//  MyCellarWineListPage.swift
//  MyCellarWineListPage
//
//  Created by Josh Freed on 9/11/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import XCTest

class MyCellarWineListPage {
    private let app: XCUIApplication
    
    var title: String { app.navigationBars.staticTexts.firstMatch.label }

    var numberOfWines: Int {
        print(app.debugDescription)
        return app.tables["WineCellarListView"].cells.count
    }

    init(app: XCUIApplication) throws {
        self.app = app
        guard app.tables["WineCellarListView"].waitForExistence(timeout: .default) else { throw PageErrors.wrongPage }
    }

    func getWine(at index: Int) -> MyWineListItem {
        MyWineListItem(app: app, el: app.tables.cells.element(boundBy: index))
    }

    func goBack() throws -> MyCellarPage {
        app.navigationBars.buttons.element(boundBy: 0).tap()
        return try MyCellarPage(app: app)
    }
}

struct MyWineListItem {
    var name: String { el.staticTexts.firstMatch.label }

    private let app: XCUIApplication
    private let el: XCUIElement

    init(app: XCUIApplication, el: XCUIElement) {
        self.app = app
        self.el = el
    }

    func tap() throws -> EditWinePage {
        el.tap()
        return try EditWinePage(app: app)
    }
}
