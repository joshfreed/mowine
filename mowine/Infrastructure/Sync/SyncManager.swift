//
//  SyncManager.swift
//  mowine
//
//  Created by Josh Freed on 9/9/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib
import SwiftyBeaver

class SyncManager {
//    let dynamoDb: DynamoDbService
//    let coreData: CoreDataService
    
    init(dynamoDb: DynamoDbService, coreData: CoreDataService) {
//        self.dynamoDb = dynamoDb
//        self.coreData = coreData
    }
    
    func sync() {
        SwiftyBeaver.info("Starting sync")
        
        syncTypes()
        syncUsers()
        syncFriendships()
//        syncWines()
    }
    
    func syncTypes() {
        let remoteWineTypeStore = MemoryWineTypeRepository()
        let localWineTypeStore = CoreDataLocalDataStore<WineType>(coreDataWorker: Container.shared.coreDataWorker)
        let wineTypeSyncer = SyncManager2(remoteDataStore: remoteWineTypeStore, localDataStore: localWineTypeStore)
        
        wineTypeSyncer.syncObjects { result in
            switch result {
            case .success: SwiftyBeaver.info("Wine types synced successfully.")
            case .failure(let error): SwiftyBeaver.error("Error syncing wine types. Error: \(error)")
            }
        }
/*
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
 */
    }
    
    func syncUsers() {
        let remoteUserStore = DynamoDbRemoteDataStore<User>(dynamoDbWorker: Container.shared.dynamoDbWorker)
        let localUserStore = CoreDataLocalDataStore<User>(coreDataWorker: Container.shared.coreDataWorker)
        let userSyncer = SyncManager2(remoteDataStore: remoteUserStore, localDataStore: localUserStore)
        
        userSyncer.syncObjects { result in
            switch result {
            case .success: SwiftyBeaver.info("Users synced successfully.")
            case .failure(let error): SwiftyBeaver.error("Error syncing users. Error: \(error)")
            }
        }
        
//        syncUsers() { result in
//            switch result {
//            case .success: print("Synced users")
//            case .failure(let error): print("Error syncing users: \(error)")
//            }
//        }

    }
    
    func syncFriendships() {
        let remoteUserStore = DynamoDbRemoteDataStore<Friendship>(dynamoDbWorker: Container.shared.dynamoDbWorker)
        let localUserStore = CoreDataLocalDataStore<Friendship>(coreDataWorker: Container.shared.coreDataWorker)
        let syncer = SyncManager2(remoteDataStore: remoteUserStore, localDataStore: localUserStore)
        
        syncer.syncObjects { result in
            switch result {
            case .success: SwiftyBeaver.info("Friendships synced successfully.")
            case .failure(let error): SwiftyBeaver.error("Error syncing Friendships. Error: \(error)")
            }
        }
    }
    
/*
    func syncUsers2(completion: @escaping (EmptyResult) -> ()) {
        SwiftyBeaver.info("Starting users")
        
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
    */
    func syncWines() {
        let remoteUserStore = DynamoDbRemoteDataStore<Wine>(dynamoDbWorker: Container.shared.dynamoDbWorker)
        let localUserStore = CoreDataLocalDataStore<Wine>(coreDataWorker: Container.shared.coreDataWorker)
        let syncer = SyncManager2(remoteDataStore: remoteUserStore, localDataStore: localUserStore)
        
        syncer.syncObjects { result in
            switch result {
            case .success: SwiftyBeaver.info("Wines synced successfully.")
            case .failure(let error): SwiftyBeaver.error("Error syncing wines. Error: \(error)")
            }
        }

//        syncWines() { result in
//            switch result {
//            case .success: print("Synced wines")
//            case .failure(let error): print("Error syncing wines: \(error)")
//            }
//        }
    }
    
    /*
    func syncWines2(completion: @escaping (EmptyResult) -> ()) {
        SwiftyBeaver.info("Starting wines")
        
        dynamoDb.scanWines { result in
            switch result {
            case .success(let remoteWines):
                self.syncWinesRemoteToLocal(remoteWines)
                self.syncWinesLocalToRemote()
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func syncWinesRemoteToLocal(_ remoteWines: [Wine]) {
        for remoteWine in remoteWines {
            if let localWine = coreData.findManagedWine(by: remoteWine.id) {
                // This wine is already in the local db.
                // If the local wine is not modified and the remote wine HAS been modified;
                // then update the local wine
                if localWine.syncStatus == SyncStatus.synced.rawValue && remoteWine.updatedAt > localWine.updatedAt! {
                    SwiftyBeaver.debug("Updating local wine from remote", context: ["wineId": remoteWine.id.uuidString])
                    remoteWine.map(to: localWine, coreData: coreData)
                    localWine.syncStatus = Int16(SyncStatus.synced.rawValue)
                }
            } else {
                // Insert wine created from remote
                SwiftyBeaver.debug("Inserting new wine from remote")
                let localWine = ManagedWine(context: coreData.context)
                remoteWine.map(to: localWine, coreData: coreData)
                localWine.syncStatus = Int16(SyncStatus.synced.rawValue)
            }
        }
        
        let localWines = coreData.getAllManagedWines()
        
        for localWine in localWines {
            if localWine.syncStatus == SyncStatus.created.rawValue {
                continue
            }
            
            if !remoteWines.contains(where: { $0.id == localWine.wineId! }) {
                SwiftyBeaver.debug("Deleting wine from core data not found in remote")
                localWine.syncStatus = Int16(SyncStatus.synced.rawValue)
                coreData.context.delete(localWine)
            }
        }
        
        coreData.save()
    }
    
    private func syncWinesLocalToRemote() {
        let localWines = coreData.getAllManagedWines()
        
        // todo sync with dispatch groups?! update core data the end
        
        for localWine in localWines {
            let syncStatus = SyncStatus(rawValue: Int(localWine.syncStatus))!
            switch syncStatus {
            case .synced: break
            case .created:
                SwiftyBeaver.debug("Sending new wine to AWS")
                dynamoDb.saveWine(Wine.fromManagedWine(localWine)!, completion: nil)
            case .deleted:
                SwiftyBeaver.debug("Removing locally deleted wine from AWS")
                dynamoDb.deleteWine(Wine.fromManagedWine(localWine)!, completion: nil)
            case .modified:
                SwiftyBeaver.debug("Sending modified wine to AWS")
                dynamoDb.saveWine(Wine.fromManagedWine(localWine)!, completion: nil)
            }
            localWine.syncStatus = Int16(SyncStatus.synced.rawValue)
        }
        
        coreData.save()
    }
*/
}

