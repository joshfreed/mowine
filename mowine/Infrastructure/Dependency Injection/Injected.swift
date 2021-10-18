//
//  Injected.swift
//  mowine
//
//  Created by Josh Freed on 10/18/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation

@propertyWrapper
struct Injected<T> {
    var wrappedValue: T {
        try! JFContainer.shared.resolve()
    }
}
