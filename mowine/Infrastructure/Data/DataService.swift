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
    func getData(url: Url, completion: @escaping (Result<Data?, Error>) -> ())
}

protocol DataWriteService {
    associatedtype Url: DataUrl
    func putData(_ data: Data, url: Url, completion: @escaping (Result<URL, Error>) -> ())
}

protocol DataServiceProtocol {
    associatedtype GetDataUrl: DataUrl
    associatedtype PutDataUrl: DataUrl
    func getData(url: GetDataUrl, completion: @escaping (Result<Data?, Error>) -> ())
    func putData(_ data: Data, url: PutDataUrl, completion: @escaping (Result<URL, Error>) -> ())
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
    
    func getData(url: RemoteRead.Url, completion: @escaping (Result<Data?, Error>) -> ()) {
        SwiftyBeaver.verbose("Getting data... [\(url.cacheKey)]")

        if let cachedImage = dataCache.object(forKey: url.cacheKey) {
            SwiftyBeaver.debug("Found data in NSCache [\(url.cacheKey)]")
            completion(.success(cachedImage as Data))
            return
        }

        SwiftyBeaver.debug("Data not found in caches; fetching from remote. [\(url.cacheKey)]")

        remoteRead.getData(url: url) { result in
            if case let .success(data) = result, let nsdata = data as NSData? {
                self.dataCache.setObject(nsdata, forKey: url.cacheKey)
            }
            SwiftyBeaver.debug("Data fetch complete. [\(url.cacheKey)]")
            completion(result)
        }
    }
    
    func putData(_ data: Data, url: RemoteWrite.Url, completion: @escaping (Result<URL, Error>) -> ()) {
        SwiftyBeaver.debug("Storing data. [\(url.cacheKey)]")
        dataCache.setObject(data as NSData, forKey: url.cacheKey)
        remoteWrite.putData(data, url: url, completion: completion)
    }
}

