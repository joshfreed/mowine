//
//  RatingPicker.swift
//  mowineUITests
//
//  Created by Josh Freed on 10/18/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import XCTest

struct RatingPicker {
    private let el: XCUIElement

    init(el: XCUIElement) throws {
        self.el = el
        guard el.buttons["Rating_1"].exists else { throw PageErrors.illegalState }
    }

    func rate(_ rating: Int) throws {
        guard rating > 0 && rating <= 5 else { throw PageErrors.invalidArgument }
        el.buttons["Rating_\(rating)"].tap()
    }
}
