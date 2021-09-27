//
//  GetWineByIdQueryHandler.swift
//  GetWineByIdQueryHandler
//
//  Created by Josh Freed on 9/8/21.
//

import Foundation

public class GetWineByIdQueryHandler {
    let wineRepository: WineRepository

    public init(wineRepository: WineRepository) {
        self.wineRepository = wineRepository
    }
    
    // TODO Change this return type
    public func handle(wineId: String) async throws -> Wine? {
        try await wineRepository.getWine(by: WineId(string: wineId))
    }
}
