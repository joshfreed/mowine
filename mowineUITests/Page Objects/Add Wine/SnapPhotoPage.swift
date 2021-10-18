//
//  SnapPhotoPage.swift
//  mowineUITests
//
//  Created by Josh Freed on 10/18/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import XCTest

struct SnapPhotoPage {
    private let app: XCUIApplication

    init(app: XCUIApplication) throws {
        self.app = app
        guard app.staticTexts["Snap the Bottle"].waitForExistence(timeout: .default) else { throw PageErrors.wrongPage }
    }

    func takePhoto() {
        fatalError("Not implemented")
    }

    func chooseFromLibrary() {
        fatalError("Not implemented")
    }

    func takeLater() throws -> FinalizeWinePage {
        app.buttons["Take Later"].tap()
        return try FinalizeWinePage(app: app)
    }
}
