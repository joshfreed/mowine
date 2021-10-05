//
//  AddWineTests.swift
//  AddWineTests
//
//  Created by Josh Freed on 1/7/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import XCTest

class AddWineTests: XCTestCase {

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        let app = XCUIApplication()
        app.launchArguments.append("UI_TESTING")
        app.launch()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAddWine() {
        let app = XCUIApplication()
        
        XCTAssertTrue(app.navigationBars["My Cellar"].waitForExistence(timeout: .default))
        
        app.tabBars["Tab Bar"].buttons["Add Wine"].tap()
        
        XCTAssertTrue(app.buttons["Red"].waitForExistence(timeout: .default))
        app.buttons["Red"].tap()
        
        app.buttons["Malbec"].tap()
        
        // Photo - take it later
        app.buttons["Take Later"].tap()
        
        // Type a name
        XCTAssertTrue(app.textFields["wineName"].waitForExistence(timeout: .default))
        app.textFields["wineName"].tap()
        app.textFields["wineName"].typeText("My Test Wine")
        
        // Rate it
        XCTAssertTrue(app.buttons["Star3"].waitForExistence(timeout: .default))
        app.buttons["Star3"].tap()
        
        // Save it!
        XCTAssertTrue(app.buttons["createWineButton"].waitForExistence(timeout: .default))
        app.buttons["createWineButton"].tap()

        // Modal should close
        // blah this always returns true because the navigation bar is *behind* the modal
        XCTAssertTrue(app.navigationBars["My Cellar"].waitForExistence(timeout: .default))
        
        // Make sure the new wine is in there
        app.buttons["Show My Red Wines"].tap()
        XCTAssertTrue(app.navigationBars["Red Wines"].waitForExistence(timeout: .default))
        XCTAssertTrue(app.tables.staticTexts["My Test Wine"].exists)
    }
}
