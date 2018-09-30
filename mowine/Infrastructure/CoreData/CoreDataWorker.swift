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
    func toManagedObject(in context: NSManagedObjectContext) -> ManagedType?
    func mapToManagedObject(_ managedObject: ManagedType)
    func getIdPredicate() -> NSPredicate
}

protocol CoreDataWorkerProtocol {
    func get<Entity: CoreDataConvertible> (with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, from context: NSManagedObjectContext) throws -> [Entity]
    func get<Entity: CoreDataConvertible> (with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, completion: @escaping (Result<[Entity]>) -> ())
    func getOne<Entity: CoreDataConvertible>(_ entity: Entity, from context: NSManagedObjectContext) throws -> Entity.ManagedType?
    func insert<Entity>(_ entity: Entity, in context: NSManagedObjectContext) throws where Entity : CoreDataConvertible
    func update<Entity>(_ entity: Entity, in context: NSManagedObjectContext) throws where Entity : CoreDataConvertible
    func delete<Entity>(_ entity: Entity, from context: NSManagedObjectContext) throws where Entity : CoreDataConvertible
}

enum CoreDataError: Error {
    case entityNotFound
}

class CoreDataWorker: CoreDataWorkerProtocol {
    let container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    func get<Entity: CoreDataConvertible> (with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, from context: NSManagedObjectContext) throws -> [Entity] {
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
    
    func get<Entity>(with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, completion: @escaping (Result<[Entity]>) -> ()) where Entity : CoreDataConvertible {
        container.performBackgroundTask { context in
            do {
                let results: [Entity] = try self.get(with: predicate, sortDescriptors: sortDescriptors, from: context)
                completion(.success(results))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getOne<Entity>(_ entity: Entity, from context: NSManagedObjectContext) throws -> Entity.ManagedType? where Entity : CoreDataConvertible {
        let fetchRequest = Entity.ManagedType.fetchRequest()
        fetchRequest.predicate = entity.getIdPredicate()
        let results = try context.fetch(fetchRequest) as? [Entity.ManagedType]
        return results?.first
    }
    
    func insert<Entity>(_ entity: Entity, in context: NSManagedObjectContext) throws where Entity : CoreDataConvertible {
        _ = entity.toManagedObject(in: context)
    }
    
    func update<Entity>(_ entity: Entity, in context: NSManagedObjectContext) throws where Entity : CoreDataConvertible {
        guard let managedEntity = try getOne(entity, from: context) else {
            throw CoreDataError.entityNotFound
        }
        entity.mapToManagedObject(managedEntity)
    }
    
    func delete<Entity>(_ entity: Entity, from context: NSManagedObjectContext) throws where Entity : CoreDataConvertible {
        guard let managedEntity = try getOne(entity, from: context) else {
            return
        }
        
        context.delete(managedEntity)
    }
}
