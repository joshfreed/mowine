//
//  MyCellarViewModel.swift
//  mowine
//
//  Created by Josh Freed on 10/11/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI
import SwiftyBeaver

class MyCellarViewModel: ObservableObject {
    let wineTypeRepository: WineTypeRepository

    var red: WineType { wineTypes.first { $0.name == "Red" }! }
    var white: WineType { wineTypes.first { $0.name == "White" }! }
    var rose: WineType { wineTypes.first { $0.name == "Rosé" }! }
    var bubbly: WineType { wineTypes.first { $0.name == "Bubbly" }! }
    var other: WineType { wineTypes.first { $0.name == "Other" }! }

    private var wineTypes: [WineType] = []

    init(wineTypeRepository: WineTypeRepository) {
        SwiftyBeaver.debug("init")
        self.wineTypeRepository = wineTypeRepository
        loadWineTypes()
    }

    deinit {
        SwiftyBeaver.debug("deinit")
    }

    func loadWineTypes() {
        wineTypeRepository.getAll { result in
            switch result {
            case .success(let types): self.wineTypes = types
            case .failure(let error): break
            }
        }
    }
}
