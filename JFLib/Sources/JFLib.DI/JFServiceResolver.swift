//
//  File.swift
//  
//
//  Created by Josh Freed on 10/21/21.
//

import Foundation

public protocol JFServiceResolver {
    func resolve<T>() throws -> T
}
