//
//  SyncManager.swift
//  mowine
//
//  Created by Josh Freed on 9/9/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation

class SyncManager {
    func sync() {
        // Need to:
        // - Send newly created wines to the server
        // - Updated edited wines on the server
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
    }
}
