//
//  mowineUITests.swift
//  mowineUITests
//
//  Created by Josh Freed on 1/7/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import XCTest
import Nimble

extension XCTestCase {
    func toString(_ object: [[String: Any]]) -> String {
        let data = try! JSONSerialization.data(withJSONObject: object, options: [])
        return String(data: data, encoding: .utf8)!
    }
}

class mowineUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        let app = XCUIApplication()
        app.launchArguments.append("UI_TESTING")
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddWine() {
        let app = XCUIApplication()
        
        let exists1 = app.navigationBars["My Cellar"].waitForExistence(timeout: 5)
        expect(exists1).to(beTrue())
        
        app.tabBars["Tab Bar"].buttons["Add Wine"].tap()
        
        _ = app.buttons["Red"].waitForExistence(timeout: 3)
        XCTAssertTrue(app.buttons["Red"].exists)
        app.buttons["Red"].tap()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Malbec"].tap()
        
        // Photo - take it later
        app.buttons["Take Later"].tap()
        
        // Type a name
        app.textFields["wineName"].typeText("My Test Wine")
        
        // Rate it
        elementsQuery.otherElements["Rating"].tap()
        
        // Save it!
        elementsQuery.buttons["Add Wine"].tap()

        // Modal should close
        let exists = app.navigationBars["My Cellar"].waitForExistence(timeout: 5)
        expect(exists).to(beTrue())
        
        // Make sure the new wine is in there
        app.buttons["Show My Red Wines"].tap()
        let exists2 = app.navigationBars["Red Wines"].waitForExistence(timeout: 5)
        expect(exists2).to(beTrue())
        XCTAssertTrue(app.tables.staticTexts["My Test Wine"].exists)
    }
    
}
