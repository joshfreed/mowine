//
//  EditWineTests.swift
//  EditWineTests
//
//  Created by Josh Freed on 9/11/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import XCTest

class EditWineTests: XCTestCase {
    var mowine: MoWineApp!
    var myCellarPage: MyCellarPage!
    var wineListPage: MyCellarWineListPage!
    var editWinePage: EditWinePage!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        app.launchArguments.append("UI_TESTING")
        app.launchEnvironment["loggedInUser"] = ["emailAddress": "editwine@jpfreed.com", "password": "Testing123!"].toJsonString()
        app.launch()

        mowine = MoWineApp(app: app)
        myCellarPage = MyCellarPage(app: app)
        wineListPage = MyCellarWineListPage(app: app)
        editWinePage = EditWinePage(app: app)
    }

    func testEditWine() throws {
        mowine.waitForExistence()

        myCellarPage.showMyRedWines()
        wineListPage.waitForExistence(wineTypes: "Red Wines")
        wineListPage.assertContainsWine(named: "My Original Name")

        wineListPage.selectWine(at: 0)

        editWinePage.waitForExistence()
        editWinePage.setWineName("My Updated Name")
        editWinePage.updateRating(to: 1)
        editWinePage.changeType(to: "White")
        editWinePage.changeVariety(to: "Pinot Blanc")
        editWinePage.setLocation("Wegman's")
        editWinePage.setPrice("$50")
        editWinePage.addPairing("Sushi")
        editWinePage.addPairing("Cheese")
        editWinePage.setNote("This is my note")

        editWinePage.saveWine()

        wineListPage.waitForExistence(wineTypes: "Red Wines")
        wineListPage.assertDoesNotContainWine(named: "My Original Name")

        wineListPage.goBack()

        myCellarPage.waitForExistence()
        myCellarPage.showMyWhiteWines()

        wineListPage.waitForExistence(wineTypes: "White Wines")
        wineListPage.assertContainsWine(named: "My Updated Name")
    }
}
