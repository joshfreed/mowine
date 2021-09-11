//
//  MyCellarPage.swift
//  MyCellarPage
//
//  Created by Josh Freed on 9/11/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import XCTest

class MyCellarPage {
    let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }

    func waitForExistence() {
        XCTAssertTrue(app.navigationBars["My Cellar"].waitForExistence(timeout: 5))
    }

    func showMyRedWines() {
        app.buttons["Show My Red Wines"].tap()
    }

    func showMyWhiteWines() {
        app.buttons["Show My White Wines"].tap()
    }
}
