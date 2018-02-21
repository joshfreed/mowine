//
//  CoreDataWineTypeRepository.swift
//  mowine
//
//  Created by Josh Freed on 2/20/18.
//  Copyright © 2018 BleepSmazz. All rights reserved.
//

import UIKit
import JFLib
import CoreData

class CoreDataWineTypeRepository: WineTypeRepository {
    let container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    func getAll(completion: @escaping (Result<[WineType]>) -> ()) {
        
    }
    
    func getWineType(named name: String, completion: @escaping (Result<WineType?>) -> ()) {
        let context = container.viewContext
        let request: NSFetchRequest<ManagedWineType> = ManagedWineType.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let types: [ManagedWineType] = try context.fetch(request)
            let managedType = types.first
            if let managedType = managedType {
                let model = CoreDataWineTypeTranslator.makeModel(from: managedType)
                completion(.success(model))
            } else {
                completion(.success(nil))
            }
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

class CoreDataWineTypeTranslator {
    static func makeModel(from entity: ManagedWineType) -> WineType? {
        guard let name = entity.name else {
            return nil
        }
        let varieties = (entity.varieties?.allObjects as? [ManagedWineVariety] ?? []).flatMap({ CoreDataVarietyTranslator.makeModel(from: $0) })
        return WineType(name: name, varieties: varieties)
    }
    
    static func makeEntity(from model: WineType, in context: NSManagedObjectContext) -> ManagedWineType {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "WineType", into: context) as! ManagedWineType
        entity.name = model.name
        return entity
    }
}

class CoreDataVarietyTranslator {
    static func makeModel(from entity: ManagedWineVariety) -> WineVariety? {
        guard let name = entity.name else {
            return nil
        }
        return WineVariety(name: name)
    }
}
