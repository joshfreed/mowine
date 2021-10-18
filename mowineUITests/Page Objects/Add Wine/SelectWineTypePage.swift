//
//  SelectWineTypePage.swift
//  mowineUITests
//
//  Created by Josh Freed on 10/18/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import XCTest

class AddWine {}

extension AddWine {
    struct SelectWineTypePage {
        private let app: XCUIApplication

        init(app: XCUIApplication) throws {
            self.app = app
            guard app.scrollViews["SelectType"].waitForExistence(timeout: .default) else { throw PageErrors.wrongPage }
        }

        func selectType(_ typeName: String) throws -> SelectWineVarietyPage {
            app.buttons[typeName].tap()
            return try SelectWineVarietyPage(app: app)
        }

//        func selectTypeWithoutVarieties(_ named: String) throws -> SnapPhotoPage {
//            app.buttons[typeName].tap()
//            return try SnapPhotoPage(app: app)
//        }
    }

    struct SelectWineVarietyPage {
        private let app: XCUIApplication

        init(app: XCUIApplication) throws {
            self.app = app
            guard app.scrollViews["SelectVariety"].waitForExistence(timeout: .default) else { throw PageErrors.wrongPage }
        }

        func selectVariety(_ varietyName: String) throws -> SnapPhotoPage {
            app.buttons[varietyName].tap()
            return try SnapPhotoPage(app: app)
        }
    }
}
