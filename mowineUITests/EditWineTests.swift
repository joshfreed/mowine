//
//  EditWineTests.swift
//  EditWineTests
//
//  Created by Josh Freed on 9/11/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import XCTest

class EditWineTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        app.launchArguments.append("UI_TESTING")
        app.launchEnvironment["loggedInUser"] = ["emailAddress": "editwine@jpfreed.com", "password": "Testing123!"].toJsonString()
        app.launch()
    }

    func testEditWine() throws {
        let app = XCUIApplication()
        var myCellarPage = try MyCellarPage(app: app)
        var wineListPage: MyCellarWineListPage!

        wineListPage = try myCellarPage.showMyRedWines()
        XCTAssertEqual("Red Wines", wineListPage.title)
        XCTAssertEqual(1, wineListPage.numberOfWines)

        let existingWineItem = try wineListPage.getWine(at: 0)
        XCTAssertEqual("My Original Name", existingWineItem.name)
        XCTAssertEqual(5, existingWineItem.rating)

        let editWinePage = try existingWineItem.tap()

        editWinePage.setWineName("My Updated Name")
        try editWinePage.updateRating(to: 1)
        try editWinePage.changeType(to: "White")
        try editWinePage.changeVariety(to: "Pinot Blanc")
        editWinePage.setLocation("Wegman's")
        editWinePage.setPrice("$50")
        app.keyboards.buttons["Return"].tap()
        editWinePage.addPairing("Sushi")
        editWinePage.addPairing("Cheese")
        editWinePage.setNote("This is my note")

        wineListPage = try editWinePage.saveWine()
        
        XCTAssertEqual(0, wineListPage.numberOfWines)

        myCellarPage = try wineListPage.goBack()

        wineListPage = try myCellarPage.showMyWhiteWines()
        XCTAssertEqual("White Wines", wineListPage.title)
        XCTAssertEqual(1, wineListPage.numberOfWines)

        let updatedWineItem = try wineListPage.getWine(at: 0)
        XCTAssertEqual("My Updated Name", updatedWineItem.name)
        XCTAssertEqual(1, existingWineItem.rating)
    }
}
