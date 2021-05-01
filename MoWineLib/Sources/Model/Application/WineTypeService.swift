//
//  WineTypeService.swift
//  
//
//  Created by Josh Freed on 4/24/21.
//

import Foundation
import SwiftyBeaver

public class WineTypeService: ObservableObject {
    @Published public private(set) var wineTypes: [WineType] = []

    public var red: WineType { wineTypes.first { $0.name == "Red" }! }
    public var white: WineType { wineTypes.first { $0.name == "White" }! }
    public var rose: WineType { wineTypes.first { $0.name == "Rosé" }! }
    public var bubbly: WineType { wineTypes.first { $0.name == "Bubbly" }! }
    public var other: WineType { wineTypes.first { $0.name == "Other" }! }

    private let wineTypeRepository: WineTypeRepository

    public init(wineTypeRepository: WineTypeRepository) {
        self.wineTypeRepository = wineTypeRepository
    }

    public func fetchWineTypes() {
        wineTypeRepository.getAll { result in
            switch result {
            case .success(let types): self.wineTypes = types
            case .failure(let error): SwiftyBeaver.error("\(error)")
            }
        }
    }
}
