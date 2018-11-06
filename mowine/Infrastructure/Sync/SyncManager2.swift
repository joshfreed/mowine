//
//  SyncManager2.swift
//  mowine
//
//  Created by Josh Freed on 9/30/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib
import SwiftyBeaver

class SyncManager2<TRemoteDataStore, TLocalDataStore> where TRemoteDataStore: RemoteDataStore, TLocalDataStore : LocalDataStore, TRemoteDataStore.Entity == TLocalDataStore.Entity {
    let remoteDataStore: TRemoteDataStore
    let localDataStore: TLocalDataStore
    
    init(remoteDataStore: TRemoteDataStore, localDataStore: TLocalDataStore) {
        self.remoteDataStore = remoteDataStore
        self.localDataStore = localDataStore
    }
    
    private var entityName: String {
        return String(describing: TRemoteDataStore.Entity.self)
    }
    
    func syncObjects(completion: @escaping (EmptyResult) -> ()) {
        SwiftyBeaver.info("Starting sync for \(entityName)")
        
        remoteDataStore.fetchAll() { result in
            switch result {
            case .success(let remoteObjects): self.doSync(remoteObjects, completion: completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    private func doSync(_ remoteObjects: [TRemoteDataStore.Entity], completion: @escaping (EmptyResult) -> ()) {
        syncRemoteToLocal(remoteObjects) { result in
            switch result {
            case .success: self.syncLocalToRemote(completion: completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func syncRemoteToLocal(_ remoteObjects: [TRemoteDataStore.Entity], completion: @escaping(EmptyResult) -> ()) {
        localDataStore.open {
            do {
                try self.syncRemoteToLocal(remoteObjects)
                completion(.success)
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    private func syncRemoteToLocal(_ remoteObjects: [TRemoteDataStore.Entity]) throws {
        for remoteObject in remoteObjects {
            if var localObject = try localDataStore.getFor(remoteObject) {
                if localObject.syncState == .synced, remoteObject.updatedAt > localObject.updatedAt {
                    SwiftyBeaver.verbose("[\(entityName)] Updating local object with remote changes", context: [String(describing: TRemoteDataStore.Entity.self)])
                    try localDataStore.update(remoteObject)
                }                
            } else {
                SwiftyBeaver.verbose("[\(entityName)] Inserting new object from remote")
                try localDataStore.insert(remoteObject)
            }
        }
        
        let localObjects: [TLocalDataStore.Entity] = try localDataStore.getAll()
        
        for localObject in localObjects {
            if localObject.syncState == .created {
                continue
            }
            
            if !remoteObjects.contains(where: { $0.identifier == localObject.identifier }) {
                SwiftyBeaver.debug("[\(entityName)] Deleting local object not found in remote")
                try localDataStore.delete(localObject)
            }
        }
        
        localDataStore.save()
    }
    
    func syncLocalToRemote(completion: @escaping (EmptyResult) -> ()) {
        completion(.success)
    }
}

protocol Syncable {
    var identifier: String { get }
    var syncState: SyncStatus { get }
    var updatedAt: Date { get set }
}

protocol RemoteDataStore {
    associatedtype Entity
    func fetchAll(completion: @escaping (Result<[Entity]>) -> ())
}

protocol LocalDataStore {
    associatedtype Entity: Syncable
    
    func delete(_ entity: Entity) throws
    func getAll() throws -> [Entity]
    func getFor(_ entity: Entity) throws -> Entity?    
    func insert(_ entity: Entity) throws
    func open(completion: @escaping () -> ())
    func save()
    func update(_ entity: Entity) throws
}
