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
    let coreDataWorker: CoreDataWorkerProtocol
    
    init(container: NSPersistentContainer, coreDataWorker: CoreDataWorkerProtocol) {
        self.container = container
        self.coreDataWorker = coreDataWorker
    }
    
    func getAll(completion: @escaping (Result<[WineType]>) -> ()) {
        do {
            let wineTypes: [WineType] = try coreDataWorker.get(with: nil, sortDescriptors: nil, from: container.viewContext)
            completion(.success(wineTypes))
        } catch {
            completion(.failure(error))
        }
    }
    
    func getWineType(named name: String, completion: @escaping (Result<WineType?>) -> ()) {
        let predicate = NSPredicate(format: "name == %@", name)
        do {
            let wineType: WineType? = try coreDataWorker.getOne(with: predicate, from: container.viewContext)
            completion(.success(wineType))
        } catch {
            completion(.failure(error))
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
    
    static func insert(model: WineType, in context: NSManagedObjectContext) -> ManagedWineType {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Type", into: context) as! ManagedWineType
        entity.name = model.name
        for variety in model.varieties {
            let managedVariety = ManagedWineVariety(context: context)
            managedVariety.name = variety.name
            entity.addToVarieties(managedVariety)
        }
        return entity
    }
}
