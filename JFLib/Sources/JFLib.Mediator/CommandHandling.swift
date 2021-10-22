//
//  CommandHandling.swift
//  JFLib.Mediator
//
//  Created by Josh Freed on 10/22/21.
//

import Foundation

public protocol JFMCommand {}

public protocol JFMCommandHandler {
    func handle(command: JFMCommand) async throws
}

open class BaseCommandHandler<Command: JFMCommand>: JFMCommandHandler {
    public init() {}

    public func handle(command: JFMCommand) async throws {
        guard let command = command as? Command else { throw InvalidCommandType() }
        try await handle(command: command)
    }

    open func handle(command: Command) async throws {
        fatalError("Must override concrete handler func")
    }
}

public struct InvalidCommandType: Error {}
