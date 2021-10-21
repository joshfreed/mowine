//
//  DipServiceResolver.swift
//  
//
//  Created by Josh Freed on 10/21/21.
//

import Foundation
import JFLib_DI
import Dip

public class DipServiceResolver: JFServiceResolver {
    private let container: DependencyContainer

    public init(container: DependencyContainer) {
        self.container = container
    }

    public func resolve<T>() throws -> T {
        try container.resolve()
    }
}
