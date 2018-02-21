//
//  CoreDataWineVarietyRepository.swift
//  mowine
//
//  Created by Josh Freed on 2/21/18.
//  Copyright © 2018 BleepSmazz. All rights reserved.
//

import Foundation
import CoreData
import JFLib

class CoreDataWineVarietyRepository: WineVarietyRepository {
    let container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    func getVarieties(of type: WineType, completion: @escaping (Result<[WineVariety]>) -> ()) {
        
    }
    
    func getVariety(named name: String, completion: @escaping (Result<WineVariety>) -> ()) {
        
    }
}
