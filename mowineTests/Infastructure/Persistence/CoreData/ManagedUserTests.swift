//
//  ManagedUserTests.swift
//  mowineTests
//
//  Created by Josh Freed on 11/15/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import XCTest
@testable import mowine
import CoreData
import Nimble

class ManagedUserTests: XCTestCase {
    var coreData: CoreDataHelper!
    var watcher: CoreDataSyncableWatcher!
    var userId: UserId!
    
    override func setUp() {
        continueAfterFailure = false
        coreData = CoreDataHelper.shared
        coreData.setUp()
        watcher = CoreDataSyncableWatcher(container: coreData.container)
        
        userId = UserId()
        let managedUser = ManagedUser(context: coreData.context)
        managedUser.userId = userId.asString
        managedUser.firstName = "Charlie"
        managedUser.lastName = "Kelly"
        coreData.save()
    }

    override func tearDown() {
        coreData.tearDown()
        watcher = nil
    }

    func testNewManagedUserIsMarkedCreated() {
        let found = coreData.getManagedUser(by: userId)
        expect(found).toNot(beNil())
        expect(found?.userId).to(equal(userId.asString))
        expect(found?.syncState).to(equal(Int16(SyncStatus.created.rawValue)))
    }
    
    func testCanSetSyncStateToSynced() {
        let managedUser = coreData.getManagedUser(by: userId)
        managedUser?.syncState = Int16(SyncStatus.synced.rawValue)
        coreData.save()
        expect(managedUser?.syncState).to(equal(Int16(SyncStatus.synced.rawValue)))
    }
    
    func testChangingSyncedUserMarksItModified() {
        let managedUser = coreData.getManagedUser(by: userId)
        managedUser?.syncState = Int16(SyncStatus.synced.rawValue)
        coreData.save()
        
        let userToUpdate = coreData.getManagedUser(by: userId)        
        userToUpdate?.firstName = "Green"
        userToUpdate?.lastName = "Man"
        coreData.save()
        
        let found = coreData.getManagedUser(by: userId)
        expect(found?.syncState).to(equal(Int16(SyncStatus.modified.rawValue)))
    }
}
