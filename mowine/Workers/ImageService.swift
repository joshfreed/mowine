//
// Created by Josh Freed on 2019-01-14.
// Copyright (c) 2019 Josh Freed. All rights reserved.
//

import Foundation
import JFLib
import SwiftyBeaver

protocol ImageServiceProtocol {
    func storeImage(name: String, data: Data, completion: @escaping (Result<URL>) -> ())
    func fetchImage(name: String, completion: @escaping (Result<Data?>) -> ())
}

class ImageService: ImageServiceProtocol {
    let storage: FirebaseStorageService
    let photoCache = NSCache<NSString, NSData>()

    init(storage: FirebaseStorageService) {
        self.storage = storage
    }

    func storeImage(name: String, data: Data, completion: @escaping (Result<URL>) -> ()) {
        photoCache.setObject(data as NSData, forKey: name as NSString)
        storage.putData(data, path: name, completion: completion)
    }

    func fetchImage(name: String, completion: @escaping (Result<Data?>) -> ()) {
        if let cachedImage = photoCache.object(forKey: name as NSString) {
            completion(.success(cachedImage as Data))
            return
        }

        storage.getData(path: name) { result in
            if case let .success(data) = result, let nsdata = data as NSData? {
                self.photoCache.setObject(nsdata, forKey: name as NSString)
            }
            completion(result)

        }
    }
}
