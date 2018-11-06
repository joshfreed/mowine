//
//  CoreDataMappingContext.swift
//  mowine
//
//  Created by Josh Freed on 11/3/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import CoreData

class CoreDataMappingContext {
    let worker: CoreDataWorker
    let context: NSManagedObjectContext
    
    init(worker: CoreDataWorker, context: NSManagedObjectContext) {
        self.worker = worker
        self.context = context
    }
    
    func syncOne<Entity>(_ entity: Entity) throws -> Entity.ManagedType? where Entity: CoreDataConvertible {
        guard let managedObject = try findOrCreateManagedObject(entity) else {
            return nil
        }
        try entity.mapToManagedObject(managedObject, mappingContext: self)
        return managedObject
    }
    
    func syncSet<Entity>(_ entities: [Entity]) throws -> NSSet where Entity: CoreDataConvertible {
        let managedObjects = try syncRelatedEntities(entities)
        return NSSet(array: managedObjects)
    }
    
    func syncOrderedSet<Entity>(_ entities: [Entity]) throws -> NSOrderedSet where Entity: CoreDataConvertible {
        let managedObjects = try syncRelatedEntities(entities)
        return NSOrderedSet(array: managedObjects)
    }
    
    private func syncRelatedEntities<Entity>(_ entities: [Entity]) throws -> [Entity.ManagedType] where Entity: CoreDataConvertible {
        var array: [Entity.ManagedType] = []
        for entity in entities {
            if let managedObject = try findOrCreateManagedObject(entity) {
                try entity.mapToManagedObject(managedObject, mappingContext: self)
                array.append(managedObject)
            }
        }
        return array
    }
    
    private func findOrCreateManagedObject<Entity>(_ entity: Entity) throws -> Entity.ManagedType? where Entity: CoreDataConvertible {
        if let managedObject = try worker.getManagedObject(for: entity, from: context) {
            return managedObject
        } else {
            return Entity.ManagedType(context: context)
        }
    }
}
