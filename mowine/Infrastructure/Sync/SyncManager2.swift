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

class SyncManager2<TRemoteDataStore, TLocalDataStore, TDataMapper>
where
    TRemoteDataStore: RemoteDataStore,
    TLocalDataStore: LocalDataStore,
    TDataMapper: DataMapper,
    TDataMapper.SourceType == TRemoteDataStore.Object,
    TDataMapper.DestinationType == TLocalDataStore.L
{
    let remoteDataStore: TRemoteDataStore
    let localDataStore: TLocalDataStore
    let mapper: TDataMapper
    
    init(remoteDataStore: TRemoteDataStore, localDataStore: TLocalDataStore, mapper: TDataMapper) {
        self.remoteDataStore = remoteDataStore
        self.localDataStore = localDataStore
        self.mapper = mapper
    }
    
    private var entityName: String {
        return String(describing: TRemoteDataStore.Object.self)
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
    
    private func doSync(_ remoteObjects: [TRemoteDataStore.Object], completion: @escaping (EmptyResult) -> ()) {
        syncRemoteToLocal(remoteObjects) { result in
            switch result {
            case .success: self.syncLocalToRemote(completion: completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func syncRemoteToLocal(_ remoteObjects: [TRemoteDataStore.Object], completion: @escaping(EmptyResult) -> ()) {
        localDataStore.open {
            do {
                try self.syncRemoteToLocal(remoteObjects)
                completion(.success)
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    private func syncRemoteToLocal(_ remoteObjects: [TRemoteDataStore.Object]) throws {
        for remoteObject in remoteObjects {
            if let localObject = try localDataStore.getFor(remoteObject.getId()!) {
                if let updatedAt = remoteObject.getUpdatedAt(), localObject.isModified(after: updatedAt) {
                    SwiftyBeaver.verbose("[\(entityName)] Updating local object with remote changes")
                    try mapper.map(from: remoteObject, to: localObject)
                    try localDataStore.update(localObject)
                }                
            } else {
                SwiftyBeaver.verbose("[\(entityName)] Inserting new object from remote")
                let newLocalObject = try mapper.create(from: remoteObject)
                try localDataStore.insert(newLocalObject)
            }
        }
        
        let localObjects: [TLocalDataStore.L] = try localDataStore.getAll()
        
        for localObject in localObjects {
            if localObject.isCreated() {
                continue
            }
            
            if !remoteObjects.contains(where: { $0.getId() == localObject.getId() }) {
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

protocol RemoteObject {
    func getId() -> String?
    func getUpdatedAt() -> Date?
}

protocol LocalObject {
    func getId() -> String?
    func isCreated() -> Bool
    func isModified(after date: Date) -> Bool
}

protocol RemoteDataStore {
    associatedtype Object: RemoteObject
    func fetchAll(completion: @escaping (Result<[Object]>) -> ())
}

protocol LocalDataStore {
    associatedtype L: LocalObject
    func delete(_ entity: L) throws
    func getAll() throws -> [L]
    func getFor(_ id: String) throws -> L?
    func insert(_ entity: L) throws
    func open(completion: @escaping () -> ())
    func save()
    func update(_ entity: L) throws
}

protocol DataMapper {
    associatedtype SourceType
    associatedtype DestinationType
    func create(from source: SourceType) throws -> DestinationType
    func map(from source: SourceType, to destination: DestinationType) throws
}
