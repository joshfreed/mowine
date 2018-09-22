//
//  Syncable.swift
//  mowine
//
//  Created by Josh Freed on 9/21/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation

enum SyncStatus: Int {
    case synced
    case created
    case modified
    case deleted
}

/*
protocol Syncable {
    var syncStatus: SyncStatus { get set }
    var updatedAt: Date { get set }
    
    func created()
    func modified()
    func deleted()
    func synced()
}

extension Syncable {
    mutating func created() {
        syncStatus = .created
        updatedAt = Date()
    }
    
    mutating func modified() {
        syncStatus = .modified
        updatedAt = Date()
    }
    
    mutating func deleted() {
        syncStatus = .deleted
        updatedAt = Date()
    }
    
    mutating func synced() {
        syncStatus = .synced
    }
}
*/
