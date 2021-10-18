//
//  MyWineListItem.swift
//  mowineUITests
//
//  Created by Josh Freed on 10/18/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import XCTest

struct MyWineListItem {
    private let app: XCUIApplication
    private let el: XCUIElement
    private let ratingLabel: RatingLabel

    var name: String { el.staticTexts["Wine Name"].label }

    var wineType: String { el.staticTexts["Wine Type"].label }

    var rating: Int { ratingLabel.rating }

    init(app: XCUIApplication, el: XCUIElement) throws {
        self.app = app
        self.el = el
        self.ratingLabel = try RatingLabel(el: el)
    }

    func tap() throws -> EditWinePage {
        el.tap()
        return try EditWinePage(app: app)
    }
}
