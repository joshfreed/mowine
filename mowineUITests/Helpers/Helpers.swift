//
//  Helpers.swift
//  mowineUITests
//
//  Created by Josh Freed on 10/18/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation

enum Timeout: Double {
    case `default` = 10
}

enum PageErrors: Error {
    case wrongPage
    case illegalState
    case invalidArgument
}
