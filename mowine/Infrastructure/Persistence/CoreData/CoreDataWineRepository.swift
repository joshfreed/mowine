//
//  CoreDataWineRepository.swift
//  mowine
//
//  Created by Josh Freed on 2/21/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import CoreData
import JFLib

class CoreDataWineRepository: WineRepository {
    let container: NSPersistentContainer
    let wineEntityMapper: CoreDataWineTranslator
    
    init(container: NSPersistentContainer, wineEntityMapper: CoreDataWineTranslator) {
        self.container = container
        self.wineEntityMapper = wineEntityMapper
    }
    
    func save(_ wine: Wine, completion: @escaping (Result<Wine>) -> ()) {
        let entity = findOrCreate(id: wine.id)
        wineEntityMapper.map(from: wine, to: entity)
        
        do {
            try container.viewContext.save()
            completion(.success(wine))
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    private func findOrCreate(id: UUID) -> ManagedWine {
        var entity = findById(id)
        
        if entity == nil {
            entity = ManagedWine(context: container.viewContext)
        }
        
        return entity!
    }

    private func findById(_ id: UUID) -> ManagedWine? {
        let request: NSFetchRequest<ManagedWine> = ManagedWine.fetchRequest()
        request.predicate = NSPredicate(format: "wineId == %@", id as CVarArg)
        
        do {
            return try container.viewContext.fetch(request).first
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    func getMyWines(completion: @escaping (Result<[Wine]>) -> ()) {
        let request: NSFetchRequest<ManagedWine> = ManagedWine.fetchRequest()
        
        do {
            let managedWines = try container.viewContext.fetch(request)
            let wineModels = managedWines.flatMap { wineEntityMapper.map(from: $0) }
            completion(.success(wineModels))
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func delete(_ wine: Wine, completion: @escaping (EmptyResult) -> ()) {
        guard let managedWine = findById(wine.id) else {
            completion(.success)
            return
        }
        
        container.viewContext.delete(managedWine)
        
        do {
//            try container.viewContext.save()
            completion(.success)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
