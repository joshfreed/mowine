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
    func sync() {
        SwiftyBeaver.info("Starting sync")
        
        fatalError("do not sync")
        
        syncTypes()
        syncUsers()
//        syncFriendships()
//        syncWines()
    }
    
    func syncTypes() {
        Container.shared.persistentContainer.performBackgroundTask { context in
            let memoryWineTypeRepository = MemoryWineTypeRepository()
            let coreDataMappingContext = CoreDataMappingContext(worker: Container.shared.coreDataWorker, context: context)
            
            do {
                SwiftyBeaver.info("Starting sync for WineType")
                _ = try coreDataMappingContext.syncSet(memoryWineTypeRepository.types)
                try context.save()
                SwiftyBeaver.info("Wine types synced successfully.")
            } catch {
                SwiftyBeaver.error("Error syncing wine types. Error: \(error)")
            }
        }
    }
    
    func syncUsers() {
        Container.shared.persistentContainer.performBackgroundTask { context in
            let remoteUserStore = DynamoDbRemoteDataStore<AWSUser>(dynamoDbWorker: Container.shared.dynamoDbWorker)
            let localUserStore = CoreDataLocalDataStore<ManagedUser>(coreDataWorker: Container.shared.coreDataWorker, context: context)
            let userMapper = AwsCoreDataUserMapper(context: context)
            let userSyncer = SyncManager2(remoteDataStore: remoteUserStore, localDataStore: localUserStore, mapper: userMapper)
            
            userSyncer.syncObjects { result in
                switch result {
                case .success: SwiftyBeaver.info("Users synced successfully.")
                case .failure(let error): SwiftyBeaver.error("Error syncing users. Error: \(error)")
                }
            }
        }
    }
    
    func syncFriendships() {
        /*
        let remoteUserStore = DynamoDbRemoteDataStore<Friendship>(dynamoDbWorker: Container.shared.dynamoDbWorker)
        let localUserStore = CoreDataLocalDataStore<Friendship>(coreDataWorker: Container.shared.coreDataWorker)
        let syncer = SyncManager2(remoteDataStore: remoteUserStore, localDataStore: localUserStore)
        
        syncer.syncObjects { result in
            switch result {
            case .success: SwiftyBeaver.info("Friendships synced successfully.")
            case .failure(let error): SwiftyBeaver.error("Error syncing Friendships. Error: \(error)")
            }
        }
 */
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
        /*
        let remoteUserStore = DynamoDbRemoteDataStore<Wine>(dynamoDbWorker: Container.shared.dynamoDbWorker)
        let localUserStore = CoreDataLocalDataStore<Wine>(coreDataWorker: Container.shared.coreDataWorker)
        let syncer = SyncManager2(remoteDataStore: remoteUserStore, localDataStore: localUserStore)
        
        syncer.syncObjects { result in
            switch result {
            case .success: SwiftyBeaver.info("Wines synced successfully.")
            case .failure(let error): SwiftyBeaver.error("Error syncing wines. Error: \(error)")
            }
        }
 */

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

