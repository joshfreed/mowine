//
//  WineVariety.swift
//  mowine
//
//  Created by Josh Freed on 2/21/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import CoreData

struct WineVariety: Equatable {
    var name: String
    
    public static func ==(lhs: WineVariety, rhs: WineVariety) -> Bool {
        return lhs.name == rhs.name
    }
}

// MARK: CoreDataConvertible

extension WineVariety: CoreDataConvertible {
    static func toEntity(managedObject: ManagedWineVariety) -> WineVariety? {
        guard let name = managedObject.name else {
            return nil
        }
        return WineVariety(name: name)
    }

    func mapToManagedObject(_ managedObject: ManagedWineVariety, mappingContext: CoreDataMappingContext) throws {
        managedObject.name = name
    }
    
    func getIdPredicate() -> NSPredicate {
        return NSPredicate(format: "name == %@", name)
    }
}
