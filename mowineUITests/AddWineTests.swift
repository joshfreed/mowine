//
//  AddWineTests.swift
//  AddWineTests
//
//  Created by Josh Freed on 1/7/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import XCTest

class AddWineTests: XCTestCase {
    var wineName: String!

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        let app = XCUIApplication()
        app.launchArguments.append("UI_TESTING")
        app.launch()

        let num = Int.random(in: 1..<1000)
        wineName = "My Test Wine \(num)"
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAddWine() throws {
        let app = XCUIApplication()
        let tabBar = try TabBar(app: app)

        let finalizePage = try tabBar.openAddWine()
            .selectType("Red")
            .selectVariety("Malbec")
            .takeLater()

        let myCellar = try finalizePage
            .typeName(wineName)
            .rateWine(3)
            .submitCreateWine()

        let redWinesList = try myCellar.showMyRedWines()

        XCTAssertEqual(1, redWinesList.numberOfWines)

        let wineItem = try redWinesList.getWine(at: 0)

        XCTAssertEqual(wineName, wineItem.name)
        XCTAssertEqual("Red", wineItem.wineType)
        XCTAssertEqual(3, wineItem.rating)
    }
}
