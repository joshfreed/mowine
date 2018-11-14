//
//  SyncManager2Tests.swift
//  mowineTests
//
//  Created by Josh Freed on 11/13/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import XCTest
@testable import mowine
import JFLib
import Nimble

class SyncManager2Tests: XCTestCase {
    
    class TestRemoteObj: RemoteObject {
        let id: String
        var updatedAt: Date
        var name: String = ""
        
        init(id: String, updatedAt: Date) {
            self.id = id
            self.updatedAt = updatedAt
        }
        
        func getId() -> String? {
            return id
        }
        
        func getUpdatedAt() -> Date? {
            return updatedAt
        }
    }
    
    class TestLocalObj: LocalObject {
        let id: String
        var updatedAt: Date
        var syncState: SyncStatus
        var name: String = ""
        
        init(name: String) {
            id = UUID().uuidString
            self.name = name
            self.updatedAt = Date()
            self.syncState = .created
        }
        
        init(id: String, updatedAt: Date, syncState: SyncStatus) {
            self.id = id
            self.updatedAt = updatedAt
            self.syncState = syncState
        }
        
        func getId() -> String? {
            return id
        }
        
        func getUpdatedAt() -> Date? {
            return updatedAt
        }
        
        func getSyncStatus() -> SyncStatus? {
            return syncState
        }
        
        func markSynced() {
            syncState = .synced
        }
    }
    
    class TestMapper: DataMapper {
        func create(from remote: SyncManager2Tests.TestRemoteObj) throws -> SyncManager2Tests.TestLocalObj {
            let local = TestLocalObj(id: remote.id, updatedAt: remote.updatedAt, syncState: .created)
            try map(from: remote, to: local)
            return local
        }
        
        func construct(from local: SyncManager2Tests.TestLocalObj) throws -> SyncManager2Tests.TestRemoteObj {
            let remote = TestRemoteObj(id: local.id, updatedAt: local.updatedAt)
            try map(from: local, to: remote)
            return remote
        }
        
        func map(from remote: SyncManager2Tests.TestRemoteObj, to local: SyncManager2Tests.TestLocalObj) throws {
            local.name = remote.name
        }
        
        func map(from local: SyncManager2Tests.TestLocalObj, to remote: SyncManager2Tests.TestRemoteObj) throws {
            remote.name = local.name
        }
    }
    
    class TestRemoteDataStore: RemoteDataStore {
        var remote: [TestRemoteObj] = []
        
        func fetchAll(completion: @escaping (Result<[SyncManager2Tests.TestRemoteObj]>) -> ()) {
            completion(.success(remote))
        }
        
        func insert(_ object: SyncManager2Tests.TestRemoteObj, completion: @escaping (EmptyResult) -> ()) {
            remote.append(object)
            completion(.success)
        }
        
        func update(_ object: SyncManager2Tests.TestRemoteObj, completion: @escaping (EmptyResult) -> ()) {
            guard let index = remote.index(where: { $0.getId() == object.getId() }) else {
                return
            }
            remote[index] = object
        }
        
        func delete(_ object: SyncManager2Tests.TestRemoteObj, completion: @escaping (EmptyResult) -> ()) {
            guard let index = remote.index(where: { $0.getId() == object.getId() }) else {
                return
            }
            remote.remove(at: index)
        }
    }
    
    class TestLocalDataStore: LocalDataStore {
        var local: [TestLocalObj] = []
        
        func delete(_ entity: SyncManager2Tests.TestLocalObj) throws {
            guard let index = local.index(where: { $0.getId() == entity.getId() }) else {
                return
            }
            
            local.remove(at: index)
        }
        
        func getAll() throws -> [SyncManager2Tests.TestLocalObj] {
            return local
        }
        
        func getFor(_ id: String) throws -> SyncManager2Tests.TestLocalObj? {
            return local.first(where: { $0.getId() == id })
        }
        
        func insert(_ entity: SyncManager2Tests.TestLocalObj) throws {
            local.append(entity)
        }
        
        func open(completion: @escaping () -> ()) {
            completion()
        }
        
        func save() {
            
        }
        
        func update(_ entity: SyncManager2Tests.TestLocalObj) throws {
            guard let index = local.index(where: { $0.getId() == entity.getId() }) else {
                return
            }
            
            local[index] = entity
        }
    }
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSendNewObjectToRemote() {
        let remote = TestRemoteDataStore()
        let local = TestLocalDataStore()
        let mapper = TestMapper()
        let sut = SyncManager2(remoteDataStore: remote, localDataStore: local, mapper: mapper)
        
        let obj1 = TestLocalObj(name: "Fred")
        local.local.append(obj1)
        
        sut.syncObjects { result in
            expect(result).to(self.beSuccess())
        }
        
        expect(remote.remote).to(haveCount(1))
        expect(remote.remote.first?.name).to(equal("Fred"))
        expect(obj1.syncState).to(equal(SyncStatus.synced))
    }
}
