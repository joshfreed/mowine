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

class CoreDataLocalDataStore<ManagedType>: LocalDataStore where ManagedType: CoreDataObject, ManagedType: LocalObject, ManagedType: NSManagedObject {
    let coreDataWorker: CoreDataWorkerProtocol
    private var context: NSManagedObjectContext
    
    init(coreDataWorker: CoreDataWorkerProtocol, context: NSManagedObjectContext) {
        self.coreDataWorker = coreDataWorker
        self.context = context
    }
    
    func delete(_ entity: ManagedType) throws {
        context.delete(entity)
    }

    func getAll() throws -> [ManagedType] {
        let fetchRequest = ManagedType.fetchRequest()
        let results = try context.fetch(fetchRequest) as? [ManagedType]
        return results ?? []
    }
    
    func getFor(_ id: String) throws -> ManagedType? {
        let fetchRequest = ManagedType.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(ManagedType.getIdProperty()) == %@", id)
        let results = try context.fetch(fetchRequest) as? [ManagedType]
        return results?.first
    }
    
    func insert(_ entity: ManagedType) throws {
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
//        do {
//            try context.save()
//        } catch {
//            fatalError("Failed saving context: \(error)")
//        }
    }
    
    func update(_ entity: ManagedType) throws {
        // no-op; updated by mapper?
//        try coreDataWorker.update(entity, in: context!)
    }
}
