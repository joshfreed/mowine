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

class CoreDataLocalDataStore<Entity>: LocalDataStore where Entity: CoreDataObject, Entity: LocalObject, Entity: NSManagedObject {
    let coreDataWorker: CoreDataWorkerProtocol
    private var context: NSManagedObjectContext
    
    init(coreDataWorker: CoreDataWorkerProtocol, context: NSManagedObjectContext) {
        self.coreDataWorker = coreDataWorker
        self.context = context
    }
    
    func delete(_ entity: Entity) throws {
        context.delete(entity)
    }

    func getAll() throws -> [Entity] {
        let fetchRequest = Entity.fetchRequest()
        let results = try context.fetch(fetchRequest) as? [Entity]
        return results ?? []
    }
    
    func getFor(_ id: String) throws -> Entity? {
        let fetchRequest = Entity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(Entity.getIdProperty()) == %@", id)
        let results = try context.fetch(fetchRequest) as? [Entity]
        return results?.first
    }
    
    func insert(_ entity: Entity) throws {
        // no-op; just instantiating the managed object inserts it
//        try coreDataWorker.insert(entity, in: context!)
    }
    
    func open(completion: @escaping () -> ()) {
        completion()
//        Container.shared.persistentContainer.performBackgroundTask { context in
//            self.context = context
//            completion()
//        }
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            fatalError("Failed saving context: \(error)")
        }
    }
    
    func update(_ entity: Entity) throws {
        // no-op; updated by mapper?
//        try coreDataWorker.update(entity, in: context!)
    }
}
