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

/*
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
    }
    
    func delete(_ wine: Wine, completion: @escaping (EmptyResult) -> ()) {
        do {
            try coreDataWorker.delete(wine, from: container.viewContext)
            try container.viewContext.save()
            completion(.success)
        } catch {
            completion(.failure(error))
        }
    }
    
    func getWine(by id: WineId, completion: @escaping (Result<Wine>) -> ()) {
        fatalError("Not implemented")
    }

    func getWines(userId: UserId, completion: @escaping (Result<[Wine]>) -> ()) {
        do {
            let predicate = NSPredicate(format: "user.userId == %@", userId.asString)
            let wines: [Wine] = try coreDataWorker.get(with: predicate, sortDescriptors: nil, fetchLimit: nil, from: container.viewContext)
            completion(.success(wines))
        } catch {
            completion(.failure(error))
        }
    }
    
    func getWines(userId: UserId, wineType: WineType, completion: @escaping (Result<[Wine]>) -> ()) {
        do {
            let predicate = NSPredicate(format: "user.userId == %@ && type.name == %@", userId.asString, wineType.name)
            let wines: [Wine] = try coreDataWorker.get(with: predicate, sortDescriptors: nil, fetchLimit: nil, from: container.viewContext)
            completion(.success(wines))
        } catch {
            completion(.failure(error))
        }
    }

    func getTopWines(userId: UserId, completion: @escaping (Result<[Wine]>) -> ()) {
        do {
            let predicate = NSPredicate(format: "user.userId == %@", userId.asString)
            let sortDescriptors = [NSSortDescriptor(key: "rating", ascending: false)]
            let wines: [Wine] = try coreDataWorker.get(with: predicate, sortDescriptors: sortDescriptors, fetchLimit: 5, from: container.viewContext)
            completion(.success(wines))
        } catch {
            completion(.failure(error))
        }
    }
}
*/
