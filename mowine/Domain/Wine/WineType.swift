//
//  WineType.swift
//  mowine
//
//  Created by Josh Freed on 2/21/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import CoreData

struct WineType: Equatable {
    var name: String
    var varieties: [WineVariety] = []
    
    static func ==(lhs: WineType, rhs: WineType) -> Bool {
        return lhs.name == rhs.name
    }
    
    func getVariety(named name: String) -> WineVariety? {
        return varieties.first(where: { $0.name == name })
    }
}

// MARK: CoreDataConvertible

extension WineType: CoreDataConvertible {
    static func toEntity(managedObject: ManagedWineType) -> WineType? {
        guard let name = managedObject.name else {
            return nil
        }
        
        var varieties: [WineVariety] = []
        
        if let varietiesSet = managedObject.varieties, let mngVarietiesArray = Array(varietiesSet) as? [ManagedWineVariety] {
            varieties = mngVarietiesArray.compactMap { WineVariety.toEntity(managedObject: $0) }
        }
        
        return WineType(name: name, varieties:varieties)
    }

    func mapToManagedObject(_ managedObject: ManagedWineType, mappingContext: CoreDataMappingContext) throws {
        managedObject.name = name
        managedObject.varieties = try mappingContext.syncSet(varieties)
    }

    func getIdPredicate() -> NSPredicate {
        return NSPredicate(format: "name == %@", name)
    }
}
