//
//  SyncManager.swift
//  mowine
//
//  Created by Josh Freed on 9/9/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import AWSDynamoDB
import JFLib

class SyncManager {
    let dynamoDb: DynamoDbService
    let coreData: CoreDataService
    
    init(dynamoDb: DynamoDbService, coreData: CoreDataService) {
        self.dynamoDb = dynamoDb
        self.coreData = coreData
    }
    
    func sync() {
        // Need to:
        // - Send newly created wines to the server
        // - Update edited wines on the server
        // - Remove locally deleted wines from the server
        
        // Merge in changes made by another device to this one
        // - Add wines created on another device
        // - Update wines edited on another device
        // - Remove wines deleted from another device
        
        // 1) sync remote with local
        // download "my wines"
        // any wines in the list NOT in core data should be added
        // if remote updateDate is after local updateDate, update the local wine w/ the remote data
        // if a local wine exists that is NOT in the remote list, delete the local wine
        
        // 2) send local to remote
        // look for any items with "created" status
        // look for any items with "deleted" status
        // send updates to remote. Local wines w/ updatedAt > remote date, send. Or sync status = modified?
        
        syncTypes()
        
        syncUsers() { result in
            switch result {
            case .success: print("Synced users")
            case .failure(let error): print("Error syncing users: \(error)")
            }
        }
        
        syncWines() { result in
            switch result {
            case .success: print("Synced wines")
            case .failure(let error): print("Error syncing wines: \(error)")
            }
        }
    }
    
    func syncTypes() {
        let wineTypeRepository = MemoryWineTypeRepository()
        for remoteType in wineTypeRepository.types {
            if coreData.getManagedType(for: remoteType) == nil {
                let managedType = ManagedWineType(context: coreData.context)
                managedType.name = remoteType.name
                
                for remoteVariety in remoteType.varieties {
                    var localVariety = coreData.getManagedVariety(for: remoteVariety)
                    if localVariety == nil {
                        localVariety = ManagedWineVariety(context: coreData.context)
                        localVariety?.name = remoteVariety.name
                    }
                    managedType.addToVarieties(localVariety!)
                }
            }
        }
        
        coreData.save()
    }
    
    func syncUsers(completion: @escaping (EmptyResult) -> ()) {
        dynamoDb.scanUsers { result in
            switch result {
            case .success(let users):
                self.doSync(users)
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func doSync(_ users: [User]) {
        for user in users {
            var managedUser: ManagedUser?
            
            managedUser = coreData.findManagedUser(by: user.id)
            
            if managedUser == nil {
                managedUser = ManagedUser(context: coreData.context)
            }
            
            user.toManagedUser(managedUser!)
        }
        
        coreData.save()
    }
    
    func syncWines(completion: @escaping (EmptyResult) -> ()) {
        dynamoDb.scanWines { result in
            switch result {
            case .success(let wines):
                self.doSync(wines)
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func doSync(_ remoteWines: [Wine]) {
        for remoteWine in remoteWines {
            if var localWine = coreData.findManagedWine(by: remoteWine.id) {
                // already exists; deal with merging?!?!
            } else {
                let localWine = ManagedWine(context: coreData.context)
                map(wine: remoteWine, to: localWine)
            }
        }
        
        coreData.save()
    }
    
    private func map(wine: Wine, to managedWine: ManagedWine) {
        wine.map(to: managedWine)
        
        managedWine.user = coreData.findManagedUser(by: wine.userId)
        if (managedWine.user == nil) {
            fatalError("User \(wine.userId) not in db")
        }
        
        managedWine.type = coreData.getManagedType(for: wine.type)
        if (managedWine.type == nil) {
            fatalError("Wine type \(wine.type.name) not in db")
        }
        
        if let variety = wine.variety {
            managedWine.variety = coreData.getManagedVariety(for: variety)
        } else {
            managedWine.variety = nil
        }
        
        let pairings: [ManagedFood] = wine.pairings.map {
            let mf = ManagedFood(context: coreData.context)
            mf.name = $0
            return mf
        }
        managedWine.pairings = NSSet(array: pairings)
    }
}
