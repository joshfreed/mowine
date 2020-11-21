//
//  SelectTypeWorker.swift
//  mowine
//
//  Created by Josh Freed on 2/20/18.
//  Copyright © 2018 BleepSmazz. All rights reserved.
//

import UIKit

class SelectTypeWorker {
    let wineTypeRepository: WineTypeRepository
    
    init(wineTypeRepository: WineTypeRepository) {
        self.wineTypeRepository = wineTypeRepository
    }
    
    func getWineType(named name: String, completion: @escaping (Result<WineType?, Error>) -> ()) {
        wineTypeRepository.getWineType(named: name, completion: completion)
    }
}
