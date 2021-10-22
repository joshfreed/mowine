//
//  Mediator.swift
//  JFLib.Mediator
//
//  Created by Josh Freed on 10/21/21.
//

import Foundation

public typealias CommandHandlerFactory = () -> JFMCommandHandler
public typealias QueryHandlerFactory = () -> JFMQueryHandler

public class Mediator {
    private var commandHandlers: [String: CommandHandlerFactory] = [:]
    private var queryHandlers: [String: QueryHandlerFactory] = [:]

    public init() {}
}

public struct HandlerNotFound: Error {}

// MARK: - Commands

extension Mediator {
    public func registerHandler<CommandType: JFMCommand>(
        _ handlerFactory: @autoclosure @escaping CommandHandlerFactory,
        for commandType: CommandType.Type
    ) {
        let commandName = String(describing: CommandType.self)
        commandHandlers[commandName] = handlerFactory
    }

    public func send<Command: JFMCommand>(_ command: Command) async throws {
        let commandName = String(describing: Command.self)
        guard let handlerFactory = commandHandlers[commandName] else {
            throw HandlerNotFound()
        }
        let handler = handlerFactory()
        try await handler.handle(command: command)
    }
}

// MARK: - Queries

extension Mediator {
    public func registerHandler<QueryType: JFMQuery>(
        _ handlerFactory: @autoclosure @escaping QueryHandlerFactory,
        for queryType: QueryType.Type
    ) {
        let queryName = String(describing: QueryType.self)
        queryHandlers[queryName] = handlerFactory
    }

    public func send<Query: JFMQuery, Response>(_ query: Query) async throws -> Response {
        let queryName = String(describing: Query.self)
        guard let handlerFactory = queryHandlers[queryName] else {
            throw HandlerNotFound()
        }
        let handler = handlerFactory()
        return try await handler.handle(query: query)
    }

}
