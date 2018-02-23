//
//  CoreDataVarietyTranslator.swift
//  mowine
//
//  Created by Josh Freed on 2/23/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation

class CoreDataVarietyTranslator {
    static func makeModel(from entity: ManagedWineVariety) -> WineVariety? {
        guard let name = entity.name else {
            return nil
        }
        return WineVariety(name: name)
    }
    
    static func map(from entity: ManagedWineVariety) -> WineVariety? {
        guard let name = entity.name else {
            return nil
        }
        
        return WineVariety(name: name)
    }
}
