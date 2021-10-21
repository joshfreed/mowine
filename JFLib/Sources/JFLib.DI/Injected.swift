//
//  Injected.swift
//  JFLib.DI
//
//  Created by Josh Freed on 10/18/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation

@propertyWrapper
public struct Injected<T> {
    public var wrappedValue: T { try! JFServices.resolve() }
    public init() {}
}
