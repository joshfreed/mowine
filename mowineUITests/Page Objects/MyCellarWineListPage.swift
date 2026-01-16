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

    private var listView: XCUIElement { app.collectionViews["WineCellarListView"] }

    var title: String { app.navigationBars.staticTexts.firstMatch.label }

    var numberOfWines: Int {
        listView.cells.count
    }

    init(app: XCUIApplication) throws {
        self.app = app
        guard listView.waitForExistence(timeout: .default) else { throw PageErrors.wrongPage }
    }

    func getWine(at index: Int) throws -> MyWineListItem {
        try MyWineListItem(app: app, el: listView.cells.element(boundBy: index))
    }

    func goBack() throws -> MyCellarPage {
        app.navigationBars.buttons.element(boundBy: 0).tap()
        return try MyCellarPage(app: app)
    }
}
