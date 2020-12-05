//
//  mowineUITests.swift
//  mowineUITests
//
//  Created by Josh Freed on 1/7/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import XCTest

class mowineUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddWine() {
        let app = XCUIApplication()
        
        app.tabBars["Tab Bar"].buttons["Add Wine"].tap()
        
        app.buttons["Red"].tap()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Malbec"].tap()
        
        // Photo - take it later
        app.buttons["Take Later"].tap()
        
        // Type a name
        elementsQuery.containing(.staticText, identifier:"Name and Rate").children(matching: .textField).element.typeText("My Test Wine")
        
        // Rate it
        elementsQuery.otherElements["Rating"].tap()
        
        // Save it!
        elementsQuery.buttons["Add Wine"].tap()

        // Modal should close
        
        // Make sure the new wine is in there
        
    }
    
}
