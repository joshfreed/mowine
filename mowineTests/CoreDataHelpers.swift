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

func setUpInMemoryPersistentContainer() -> NSPersistentContainer {
    let container = NSPersistentContainer(name: "mowine")
    let description = NSPersistentStoreDescription()
    description.type = NSInMemoryStoreType
    container.persistentStoreDescriptions = [description]
    
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        
    })
    
    return container
}

class CoreDataHelper {
    var container: NSPersistentContainer!
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    func setUp() {
        container = NSPersistentContainer(name: "mowine")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
        })
    }
    
    func save() {
        do {
            try container.viewContext.save()
        } catch {
            fatalError("\(error)")
        }
    }
    
    func insert(_ wineType: WineType) {
        _ = CoreDataWineTypeTranslator.insert(model: wineType, in: container.viewContext)
    }
    
    func insert(_ variety: WineVariety) {
        let entity = ManagedWineVariety(context: container.viewContext)
        entity.name = variety.name
    }
    
    func insert(_ wine: Wine) {
        let entity = ManagedWine(context: container.viewContext)
        let wineEntityMapper = CoreDataWineTranslator(context: container.viewContext)
        wineEntityMapper.map(from: wine, to: entity)
    }
}
