//
//  DataService.swift
//  mowine
//
//  Created by Josh Freed on 4/10/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import Foundation
import SwiftyBeaver

protocol DataUrl {
    var cacheKey: NSString { get }
}

extension String: DataUrl {
    var cacheKey: NSString {
        return self as NSString
    }
}

extension URL: DataUrl {
    var cacheKey: NSString {
        return self.absoluteString as NSString
    }
}

protocol DataReadService {
    associatedtype Url: DataUrl
    func getData(url: Url) async throws -> Data?
}

protocol DataWriteService {
    associatedtype Url: DataUrl
    func putData(_ data: Data, url: Url) async throws -> URL
}

protocol DataServiceProtocol {
    associatedtype GetDataUrl: DataUrl
    associatedtype PutDataUrl: DataUrl

    func getData(url: GetDataUrl) async throws -> Data?
    func putData(_ data: Data, url: PutDataUrl) async throws -> URL
}

//
// Class for reading and writing user data from any location, with caching.
//
class DataService<RemoteRead: DataReadService, RemoteWrite: DataWriteService>: DataServiceProtocol {
    let remoteRead: RemoteRead
    let remoteWrite: RemoteWrite
    let dataCache = NSCache<NSString, NSData>()
    
    init(remoteRead: RemoteRead, remoteWrite: RemoteWrite) {
        self.remoteRead = remoteRead
        self.remoteWrite = remoteWrite
    }

    func getData(url: RemoteRead.Url) async throws -> Data? {
        SwiftyBeaver.verbose("Getting data... [\(url.cacheKey)]")

        if let cachedImage = dataCache.object(forKey: url.cacheKey) {
            SwiftyBeaver.debug("Found data in NSCache [\(url.cacheKey)]")
            return cachedImage as Data
        }

        SwiftyBeaver.debug("Data not found in caches; fetching from remote. [\(url.cacheKey)]")

        let data = try await remoteRead.getData(url: url)

        if let nsdata = data as NSData? {
            dataCache.setObject(nsdata, forKey: url.cacheKey)
        }

        SwiftyBeaver.debug("Data fetch complete. [\(url.cacheKey)]")

        return data
    }
    
    func putData(_ data: Data, url: RemoteWrite.Url) async throws -> URL {
        SwiftyBeaver.debug("Storing data. [\(url.cacheKey)]")
        dataCache.setObject(data as NSData, forKey: url.cacheKey)
        return try await remoteWrite.putData(data, url: url)
    }
}

