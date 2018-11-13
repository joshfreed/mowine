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
    let coreDataWorker: CoreDataWorkerProtocol
    
    init(container: NSPersistentContainer, coreDataWorker: CoreDataWorkerProtocol) {
        self.container = container
        self.coreDataWorker = coreDataWorker
    }
    
    func add(_ wine: Wine, completion: @escaping (Result<Wine>) -> ()) {
        do {
            try coreDataWorker.insert(wine, in: container.viewContext)
            try container.viewContext.save()
            completion(.success(wine))
        } catch {
            completion(.failure(error))
        }
    }
    
    func save(_ wine: Wine, completion: @escaping (Result<Wine>) -> ()) {
        do {
            try coreDataWorker.update(wine, in: container.viewContext)
            try container.viewContext.save()
            completion(.success(wine))
        } catch {
            completion(.failure(error))
        }
        
//        guard let managedWine = coreDataService.findManagedWine(by: wine.id) else {
//            return
//        }
//
//        wine.mapToManagedObject(managedWine)
////        wine.map(to: managedWine, coreData: coreDataService)
//
//        do {
//            try container.viewContext.save()
//            completion(.success(wine))
//        } catch {
//            let nserror = error as NSError
//            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//        }
    }
    
    func delete(_ wine: Wine, completion: @escaping (EmptyResult) -> ()) {
        do {
            try coreDataWorker.delete(wine, from: container.viewContext)
            try container.viewContext.save()
            completion(.success)
        } catch {
            completion(.failure(error))
        }
        
        
//        guard let managedWine = coreDataService.findManagedWine(by: wine.id) else {
//            completion(.success)
//            return
//        }
//
//        container.viewContext.delete(managedWine)
//        completion(.success)
    }

    func getWines(userId: UserId, completion: @escaping (Result<[Wine]>) -> ()) {
        let request: NSFetchRequest<ManagedWine> = ManagedWine.fetchRequest()
        request.predicate = NSPredicate(format: "user.userId == %@", userId.asString)
        
        do {
            let managedWines = try container.viewContext.fetch(request)
            let wineModels = managedWines.compactMap { Wine.toEntity(managedObject: $0) }
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
            let wineModels = managedWines.compactMap { Wine.toEntity(managedObject: $0) }
            completion(.success(wineModels))
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    func getTopWines(userId: UserId, completion: @escaping (Result<[Wine]>) -> ()) {
        
    }
}
