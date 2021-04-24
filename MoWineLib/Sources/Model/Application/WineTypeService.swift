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
