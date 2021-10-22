//
//  CrashReporter.swift
//  mowine
//
//  Created by Josh Freed on 10/22/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import SwiftyBeaver
import FirebaseCrashlytics

class CrashReporter {
    static let shared = CrashReporter()

    private init() {}

    func record(error: Error, _ file: String = #file, _ function: String = #function, line: Int = #line) {
        SwiftyBeaver.error("\(error)", file, function, line: line)
        Crashlytics.crashlytics().record(error: error)
    }
}
