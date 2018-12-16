//
//  CoreDataHelpers.swift
//  mowine
//
//  Created by Josh Freed on 6/4/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import Foundation
import CoreData
@testable import mowine

func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
    let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
    
    let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
    
    do {
        try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
    } catch {
        print("Adding in-memory persistent store failed")
    }
    
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
    
    return managedObjectContext
}

class CoreDataHelper {
    let coreDataWorker = CoreDataWorker()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "mowine")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()

    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    static let shared = CoreDataHelper()
    
    private init() {}
    
    func setUp() {
        print("CoreDataHelper::setup")
    }
    
    func tearDown() {
        print("CoreDataHelper::tearDown")
        deleteData(entityToFetch: "Type")
        deleteData(entityToFetch: "Variety")
        deleteData(entityToFetch: "Wine")
        deleteData(entityToFetch: "User")
        deleteData(entityToFetch: "Food")
        deleteData(entityToFetch: "Friend")
        try! context.save()
    }
    
    func deleteData(entityToFetch: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: entityToFetch, in: context)
        fetchRequest.includesPropertyValues = false
        do {
            let results = try context.fetch(fetchRequest) as! [NSManagedObject]
            for result in results {
                context.delete(result)
            }
        } catch {
            fatalError("fetch error -\(error.localizedDescription)")
        }
    }
    
    func save() {
        do {
            try container.viewContext.save()
        } catch {
            fatalError("\(error)")
        }
    }
    
    func insert(_ wineType: WineType) {
        try! coreDataWorker.insert(wineType, in: container.viewContext)
    }
    
    func insert(_ variety: WineVariety) {
//        let entity = ManagedWineVariety(context: container.viewContext)
//        entity.name = variety.name
    }
    
//    func insert(_ wine: Wine) {
//        try! coreDataWorker.insert(wine, in: container.viewContext)        
//    }
    
    func insert(_ user: User) {
        try! coreDataWorker.insert(user, in: container.viewContext)
    }
    
    func getOne<T>(predicate: NSPredicate) -> T? where T: NSManagedObject {
        let fetchRequest = T.fetchRequest()
        fetchRequest.predicate = predicate
        let results = try! context.fetch(fetchRequest) as? [T]
        return results?.first
    }
    
    func getManagedUser(by userId: UserId) -> ManagedUser? {
        return getOne(predicate: NSPredicate(format: "userId == %@", userId.asString))
    }
}

class MockCoreDataWorker: CoreDataWorkerProtocol {
    func get<Entity>(with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, fetchLimit: Int?, from context: NSManagedObjectContext) throws -> [Entity] where Entity : CoreDataConvertible {
        return []
    }
    
    func get<Entity>(with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, from context: NSManagedObjectContext) throws -> [Entity] where Entity : CoreDataConvertible {
        return []
    }
    
    func getOne<Entity>(with predicate: NSPredicate?, from context: NSManagedObjectContext) throws -> Entity? where Entity : CoreDataConvertible {
        return nil
    }
    
    func insert<Entity>(_ entity: Entity, in context: NSManagedObjectContext) throws where Entity : CoreDataConvertible {
        
    }
    
    func update<Entity>(_ entity: Entity, in context: NSManagedObjectContext) throws where Entity : CoreDataConvertible {
        
    }
    
    func delete<Entity>(_ entity: Entity, from context: NSManagedObjectContext) throws where Entity : CoreDataConvertible {
        
    }
    
    func getManagedObject<Entity>(for entity: Entity, from context: NSManagedObjectContext) throws -> Entity.ManagedType? where Entity : CoreDataConvertible {
        return nil
    }
}
