//
//  DeleteWineCommandHandler.swift
//  DeleteWineCommandHandler
//
//  Created by Josh Freed on 9/3/21.
//

import Foundation
import MoWine_Domain
import JFLib_Mediator

public struct DeleteWineCommand: JFMCommand {
    public let wineId: String

    public init(wineId: String) {
        self.wineId = wineId
    }
}

public class DeleteWineCommandHandler: BaseCommandHandler<DeleteWineCommand> {
    let wineRepository: WineRepository

    public init(wineRepository: WineRepository) {
        self.wineRepository = wineRepository
    }

    public override func handle(command: DeleteWineCommand) async throws {
        let wineId = WineId(string: command.wineId)
        try await wineRepository.delete(wineId)
    }
}
