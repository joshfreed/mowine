//
//  NSError.swift
//  mowine
//
//  Created by Josh Freed on 2/18/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation

extension NSError {
    static func appError(code: NSErrorCode, userInfo: [String: String]) -> NSError {
        NSError(domain: NSAppErrorDomain, code: code.rawValue, userInfo: userInfo)
    }
}

enum NSErrorCode: Int {
    case invalidUrl = 1
}
