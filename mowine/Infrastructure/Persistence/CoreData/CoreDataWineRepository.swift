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
    let coreDataService: CoreDataService
    
    init(container: NSPersistentContainer, wineEntityMapper: CoreDataWineTranslator) {
        self.container = container
        self.wineEntityMapper = wineEntityMapper
        self.coreDataService = CoreDataService(context: container.viewContext)
    }
    
    func add(_ wine: Wine, completion: @escaping (Result<Wine>) -> ()) {
        let managedWine = ManagedWine(context: container.viewContext)
        
        map(wine: wine, to: managedWine)
        
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
        
        map(wine: wine, to: managedWine)
        
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
            let wineModels = managedWines.compactMap { wineEntityMapper.map(from: $0) }
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
            let wineModels = managedWines.compactMap { wineEntityMapper.map(from: $0) }
            completion(.success(wineModels))
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    func getTopWines(userId: UserId, completion: @escaping (Result<[Wine]>) -> ()) {
        
    }
    
    
    
    func getMyWines(completion: @escaping (Result<[Wine]>) -> ()) {
        let request: NSFetchRequest<ManagedWine> = ManagedWine.fetchRequest()
        
        do {
            let managedWines = try container.viewContext.fetch(request)
            let wineModels = managedWines.compactMap { wineEntityMapper.map(from: $0) }
            completion(.success(wineModels))
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    private func map(wine: Wine, to managedWine: ManagedWine) {
        wine.map(to: managedWine)
        
        managedWine.user = coreDataService.findManagedUser(by: wine.userId)
        if (managedWine.user == nil) {
            fatalError("User \(wine.userId) not in db")
        }
        
        managedWine.type = coreDataService.getManagedType(for: wine.type)
        if (managedWine.type == nil) {
            fatalError("Wine type \(wine.type.name) not in db")
        }
        
        if let variety = wine.variety {
            managedWine.variety = coreDataService.getManagedVariety(for: variety)
        } else {
            managedWine.variety = nil
        }
        
        let pairings: [ManagedFood] = wine.pairings.map {
            let mf = ManagedFood(context: container.viewContext)
            mf.name = $0
            return mf
        }
        managedWine.pairings = NSSet(array: pairings)
    }
}

extension Wine {
    func map(to managedWine: ManagedWine) {
        managedWine.wineId = id
        managedWine.name = name
        managedWine.rating = rating
        managedWine.location = location
        managedWine.notes = notes
        managedWine.thumbnail = thumbnail
        managedWine.createdAt = createdAt
        
        if let price = price {
            managedWine.price = NSDecimalNumber(string: price)
        } else {
            managedWine.price = nil
        }
    }
}
