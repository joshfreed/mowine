//
//  CoreDataWorker.swift
//  mowine
//
//  Created by Josh Freed on 9/30/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import CoreData
import JFLib

protocol CoreDataConvertible {
    associatedtype ManagedType: NSManagedObject
    static func toEntity(managedObject: ManagedType) -> Self?
    func mapToManagedObject(_ managedObject: ManagedType, mappingContext: CoreDataMappingContext) throws
    func getIdPredicate() -> NSPredicate
}

protocol CoreDataObject {
    static func getIdProperty() -> String
}

protocol CoreDataWorkerProtocol {
    func get<Entity: CoreDataConvertible> (with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, from context: NSManagedObjectContext) throws -> [Entity]
    func getOne<Entity>(with predicate: NSPredicate?, from context: NSManagedObjectContext) throws -> Entity? where Entity : CoreDataConvertible
    func insert<Entity>(_ entity: Entity, in context: NSManagedObjectContext) throws where Entity : CoreDataConvertible
    func update<Entity>(_ entity: Entity, in context: NSManagedObjectContext) throws where Entity : CoreDataConvertible
    func delete<Entity>(_ entity: Entity, from context: NSManagedObjectContext) throws where Entity : CoreDataConvertible
    func getManagedObject<Entity>(for entity: Entity, from context: NSManagedObjectContext) throws -> Entity.ManagedType? where Entity : CoreDataConvertible
}

protocol CoreDataContainerWorkerProtocol {
    func get<Entity: CoreDataConvertible> (with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, completion: @escaping (Result<[Entity]>) -> ())
}

enum CoreDataError: Error {
    case entityNotFound
}

class CoreDataContainerWorker: CoreDataContainerWorkerProtocol {
    let container: NSPersistentContainer
    let coreDataWorker: CoreDataWorker
    
    init(container: NSPersistentContainer) {
        self.container = container
        self.coreDataWorker = CoreDataWorker()
    }
    
    func get<Entity>(with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, completion: @escaping (Result<[Entity]>) -> ()) where Entity : CoreDataConvertible {
        container.performBackgroundTask { context in
            do {
                let results: [Entity] = try self.coreDataWorker.get(with: predicate, sortDescriptors: sortDescriptors, from: context)
                completion(.success(results))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

class CoreDataWorker: CoreDataWorkerProtocol {
    func get<Entity: CoreDataConvertible> (
        with predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]?,
        from context: NSManagedObjectContext
    ) throws -> [Entity] {
        let fetchRequest = Entity.ManagedType.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
//        if let fetchLimit = fetchLimit {
//            fetchRequest.fetchLimit = fetchLimit
//        }
        let results = try context.fetch(fetchRequest) as? [Entity.ManagedType]
        let items: [Entity] = results?.compactMap { Entity.toEntity(managedObject: $0) } ?? []
        return items
    }

    func getOne<Entity>(with predicate: NSPredicate?, from context: NSManagedObjectContext) throws -> Entity? where Entity : CoreDataConvertible {
        let fetchRequest = Entity.ManagedType.fetchRequest()
        fetchRequest.predicate = predicate
        let results = try context.fetch(fetchRequest) as? [Entity.ManagedType]
        guard let managedObject = results?.first else {
            return nil
        }
        return Entity.toEntity(managedObject: managedObject)
    }
    
    func insert<Entity>(_ entity: Entity, in context: NSManagedObjectContext) throws where Entity : CoreDataConvertible {
        let managedObject = Entity.ManagedType(context: context)
        try entity.mapToManagedObject(managedObject, mappingContext: CoreDataMappingContext(worker: self, context: context))
    }
    
    func update<Entity>(_ entity: Entity, in context: NSManagedObjectContext) throws where Entity : CoreDataConvertible {
        guard let managedEntity = try getManagedObject(for: entity, from: context) else {
            throw CoreDataError.entityNotFound
        }
        try entity.mapToManagedObject(managedEntity, mappingContext: CoreDataMappingContext(worker: self, context: context))
    }
    
    func delete<Entity>(_ entity: Entity, from context: NSManagedObjectContext) throws where Entity : CoreDataConvertible {
        guard let managedEntity = try getManagedObject(for: entity, from: context) else {
            throw CoreDataError.entityNotFound
        }
        
        context.delete(managedEntity)
    }
    
    func getManagedObject<Entity>(for entity: Entity, from context: NSManagedObjectContext) throws -> Entity.ManagedType? where Entity : CoreDataConvertible {
        let fetchRequest = Entity.ManagedType.fetchRequest()
        fetchRequest.predicate = entity.getIdPredicate()
        let results = try context.fetch(fetchRequest) as? [Entity.ManagedType]
        return results?.first
    }    
}
