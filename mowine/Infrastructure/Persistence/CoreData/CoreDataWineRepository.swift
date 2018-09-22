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
    let coreDataService: CoreDataService
    
    init(container: NSPersistentContainer) {
        self.container = container
        self.coreDataService = CoreDataService(context: container.viewContext)
    }
    
    func add(_ wine: Wine, completion: @escaping (Result<Wine>) -> ()) {
        let managedWine = ManagedWine(context: container.viewContext)
        
        wine.map(to: managedWine, coreData: coreDataService)
        
        do {
            try container.viewContext.save()
            completion(.success(wine))
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func save(_ wine: Wine, completion: @escaping (Result<Wine>) -> ()) {
        guard let managedWine = coreDataService.findManagedWine(by: wine.id) else {
            return
        }
        
        wine.map(to: managedWine, coreData: coreDataService)
        
        do {
            try container.viewContext.save()
            completion(.success(wine))
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func delete(_ wine: Wine, completion: @escaping (EmptyResult) -> ()) {
        guard let managedWine = coreDataService.findManagedWine(by: wine.id) else {
            completion(.success)
            return
        }
        
        container.viewContext.delete(managedWine)
        completion(.success)
    }

    func getWines(userId: UserId, completion: @escaping (Result<[Wine]>) -> ()) {
        let request: NSFetchRequest<ManagedWine> = ManagedWine.fetchRequest()
        request.predicate = NSPredicate(format: "user.userId == %@", userId.asString)
        
        do {
            let managedWines = try container.viewContext.fetch(request)
            let wineModels = managedWines.compactMap { Wine.fromManagedWine($0) }
            completion(.success(wineModels))
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func getWines(userId: UserId, wineType: WineType, completion: @escaping (Result<[Wine]>) -> ()) {
        let request: NSFetchRequest<ManagedWine> = ManagedWine.fetchRequest()
        request.predicate = NSPredicate(format: "user.userId == %@ && type.name == %@", userId.asString, wineType.name)
        
        do {
            let managedWines = try container.viewContext.fetch(request)
            let wineModels = managedWines.compactMap { Wine.fromManagedWine($0) }
            completion(.success(wineModels))
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    func getTopWines(userId: UserId, completion: @escaping (Result<[Wine]>) -> ()) {
        
    }
}
