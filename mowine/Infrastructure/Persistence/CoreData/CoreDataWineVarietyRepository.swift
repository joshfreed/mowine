//
//  CoreDataWineVarietyRepository.swift
//  mowine
//
//  Created by Josh Freed on 2/21/18.
//  Copyright © 2018 BleepSmazz. All rights reserved.
//

import Foundation
import CoreData
import JFLib

class CoreDataWineVarietyRepository: WineVarietyRepository {
    let container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    func getVariety(named name: String, completion: @escaping (Result<WineVariety>) -> ()) {
        let context = container.viewContext
        let request: NSFetchRequest<ManagedWineVariety> = ManagedWineVariety.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let objects: [ManagedWineVariety] = try context.fetch(request)
            if objects.count == 1 {
                let model = CoreDataVarietyTranslator.makeModel(from: objects[0])!
                completion(.success(model))
            } else {
                completion(.failure(WineVarietyRepositoryError.notFound))
            }
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}


class CoreDataVarietyTranslator {
    static func makeModel(from entity: ManagedWineVariety) -> WineVariety? {
        guard let name = entity.name else {
            return nil
        }
        return WineVariety(name: name)
    }
    
    static func map(from entity: ManagedWineVariety) -> WineVariety? {
        guard let name = entity.name else {
            return nil
        }
        
        return WineVariety(name: name)
    }
}
