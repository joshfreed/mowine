//
//  Mediator+JFLibDI.swift
//  JFLib.Mediator
//
//  Created by Josh Freed on 10/22/21.
//

import Foundation
import JFLib_DI

extension Mediator {
    public func registerHandler<CommandType: JFMCommand, HandlerType: JFMCommandHandler>(
        _ handlerType: HandlerType.Type,
        for commandType: CommandType.Type
    ) {
        let handlerFactory = { try! JFServices.resolve() as HandlerType }
        registerHandler(handlerFactory, for: CommandType.self)
    }

    public func registerHandler<QueryType: JFMQuery, HandlerType: JFMQueryHandler>(
        _ handlerType: HandlerType.Type,
        for queryType: QueryType.Type
    ) {
        let handlerFactory = { try! JFServices.resolve() as HandlerType }
        registerHandler(handlerFactory, for: QueryType.self)
    }
}
