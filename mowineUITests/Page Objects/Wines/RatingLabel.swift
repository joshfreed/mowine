//
//  RatingLabel.swift
//  mowineUITests
//
//  Created by Josh Freed on 10/18/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import XCTest

struct RatingLabel {
    private let el: XCUIElement

    var rating: Int {
        el.otherElements.matching(identifier: "Star_Filled").count
    }

    init(el: XCUIElement) throws {
        self.el = el

        guard el.otherElements["Star_Filled"].exists || el.otherElements["Star_Empty"].exists else {
            throw PageErrors.illegalState
        }
    }
}
