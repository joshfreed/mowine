//
//  QueryHandling.swift
//  JFLib.Mediator
//
//  Created by Josh Freed on 10/22/21.
//

import Foundation

public protocol JFMQuery {}

public protocol JFMQueryHandler {
    func handle<T>(query: JFMQuery) async throws -> T
}

open class BaseQueryHandler<Query: JFMQuery, Response>: JFMQueryHandler {
    public init() {}

    public func handle<T>(query: JFMQuery) async throws -> T {
        guard let query = query as? Query else { throw InvalidQueryType() }
        let response: Response = try await handle(query: query)
        return response as! T
    }

    open func handle(query: Query) async throws -> Response {
        fatalError("Must override concrete handler func")
    }
}

public struct InvalidQueryType: Error {}
