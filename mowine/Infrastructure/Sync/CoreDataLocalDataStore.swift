//
//  CoreDataLocalDataStore.swift
//  mowine
//
//  Created by Josh Freed on 9/30/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib
import CoreData

class CoreDataLocalDataStore<Entity>: LocalDataStore where Entity: CoreDataConvertible, Entity: Syncable {
    let coreDataWorker: CoreDataWorkerProtocol
    private var context: NSManagedObjectContext?
    
    init(coreDataWorker: CoreDataWorkerProtocol) {
        self.coreDataWorker = coreDataWorker
    }
    
    func delete(_ entity: Entity) throws {
        try coreDataWorker.delete(entity, from: context!)
    }

    func getAll() throws -> [Entity] {
        return try coreDataWorker.get(with: nil, sortDescriptors: nil, from: context!)
    }
    
    func getFor(_ entity: Entity) throws -> Entity? {
        let predicate = entity.getIdPredicate()
        let entities: [Entity] = try coreDataWorker.get(with: predicate, sortDescriptors: nil, from: context!)
        return entities.first
    }
    
    func insert(_ entity: Entity) throws {
        try coreDataWorker.insert(entity, in: context!)
    }
    
    func open(completion: @escaping () -> ()) {
        Container.shared.persistentContainer.performBackgroundTask { context in
            self.context = context
            completion()
        }
    }
    
    func save() {
        do {
            try context?.save()
        } catch {
            fatalError("Failed saving context: \(error)")
        }
    }
    
    func update(_ entity: Entity) throws {
        try coreDataWorker.update(entity, in: context!)
    }
}
