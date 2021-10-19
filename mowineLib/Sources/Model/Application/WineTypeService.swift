//
//  WineTypeService.swift
//  
//
//  Created by Josh Freed on 4/24/21.
//

import Foundation
import SwiftyBeaver
import MoWine_Domain

public class WineTypeService: ObservableObject {
    @Published public private(set) var wineTypes: [WineType] = []

    public var red: WineType { wineTypes.first { $0.name == "Red" } ?? .init(name: "Red") }
    public var white: WineType { wineTypes.first { $0.name == "White" } ?? .init(name: "White") }
    public var rose: WineType { wineTypes.first { $0.name == "Rosé" } ?? .init(name: "Rosé") }
    public var bubbly: WineType { wineTypes.first { $0.name == "Bubbly" } ?? .init(name: "Bubbly") }
    public var other: WineType { wineTypes.first { $0.name == "Other" } ?? .init(name: "Other") }

    private let wineTypeRepository: WineTypeRepository

    public init(wineTypeRepository: WineTypeRepository) {
        self.wineTypeRepository = wineTypeRepository
    }

    public func fetchWineTypes() async {
        do {
            let types = try await wineTypeRepository.getAll()
            self.wineTypes = types
        } catch {
            SwiftyBeaver.error("\(error)")
        }
    }
}
