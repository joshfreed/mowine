//
//  DeleteWineCommandHandler.swift
//  DeleteWineCommandHandler
//
//  Created by Josh Freed on 9/3/21.
//

import Foundation

public class DeleteWineCommandHandler {
    let wineRepository: WineRepository

    public init(wineRepository: WineRepository) {
        self.wineRepository = wineRepository
    }

    public func handle(_ wineId: String) async throws {
        let wineId = WineId(string: wineId)
        try await wineRepository.delete(wineId)
    }
}
