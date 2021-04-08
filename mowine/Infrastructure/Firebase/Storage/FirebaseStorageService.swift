//
// Created by Josh Freed on 2019-01-14.
// Copyright (c) 2019 Josh Freed. All rights reserved.
//

import Foundation
import FirebaseStorage
import SwiftyBeaver

class FirebaseStorageService {
    let storage: Storage
    private let basePath: String?

    init(basePath: String? = nil) {
        storage = Storage.storage()
        self.basePath = basePath
    }

    private func reference() -> StorageReference {
        var storageRef = storage.reference()
        if let basePath = basePath {
            storageRef = storageRef.child(basePath)
        }
        return storageRef
    }

    func putData(_ data: Data, path: String, completion: @escaping (Result<URL, Error>) -> ()) {
        let storageRef = reference()
        let uploadRef = storageRef.child(path)

        uploadRef.putData(data, metadata: nil) { (metadata, error) in
            if let err = error {
                completion(.failure(err))
                return
            }

            uploadRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url))
                } else {
                    fatalError("Firebase downloadURL did not contain an error or url")
                }
            }
        }
    }

    func getData(path: String, completion: @escaping (Result<Data?, Error>) -> ()) {
        let maxSize: Int64 = 1 * 1024 * 1024
        let storageRef = reference()
        let pathReference = storageRef.child(path)

        pathReference.getData(maxSize: maxSize) { data, error in
            if let error = error {
                let errorCode = (error as NSError).code
                guard let storageError = StorageErrorCode(rawValue: errorCode) else {
                    completion(.failure(error))
                    return
                }
                switch storageError {
                case .objectNotFound: completion(.success(nil))
                default: completion(.failure(error))
                }
            } else {
                completion(.success(data))
            }
        }
    }
}

extension FirebaseStorageService: DataReadService {
    func getData(url: String, completion: @escaping (Result<Data?, Error>) -> ()) {
        SwiftyBeaver.debug("Getting data from firebase \(url)")
        getData(path: url, completion: completion)
    }
}

extension FirebaseStorageService: DataWriteService {
    func putData(_ data: Data, url: String, completion: @escaping (Result<URL, Error>) -> ()) {
        SwiftyBeaver.debug("Putting data to firebase \(url)")
        putData(data, path: url, completion: completion)
    }
}
