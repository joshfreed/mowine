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

class DeleteWineCommandHandler: BaseCommandHandler<DeleteWineCommand> {
    private let wineRepository: WineRepository

    init(wineRepository: WineRepository) {
        self.wineRepository = wineRepository
    }

    override func handle(command: DeleteWineCommand) async throws {
        let wineId = WineId(string: command.wineId)
        try await wineRepository.delete(wineId)
    }
}
