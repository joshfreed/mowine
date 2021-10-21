//
//  JFServices.swift
//  mowine
//
//  Created by Josh Freed on 2/20/18.
//  Copyright © 2018 BleepSmazz. All rights reserved.
//

import Foundation
import Dip
import MoWine_Application
import MoWine_Domain
import MoWine_Infrastructure

public class JFServices {
    static private(set) var shared: JFServices!

    private let resolver: JFServiceResolver

    private init(resolver: JFServiceResolver) {
        self.resolver = resolver
    }

    static func initialize(resolver: JFServiceResolver) {
        assert(shared == nil)
        shared = .init(resolver: resolver)
    }

    static func resolve<T>() throws -> T {
        try shared.resolve()
    }

    func resolve<T>() throws -> T {
        try resolver.resolve()
    }
}

public protocol JFServiceResolver {
    func resolve<T>() throws -> T
}

public class DipServiceResolver: JFServiceResolver {
    private let container: DependencyContainer

    public init(container: DependencyContainer) {
        self.container = container
    }

    public func resolve<T>() throws -> T {
        try container.resolve()
    }
}
