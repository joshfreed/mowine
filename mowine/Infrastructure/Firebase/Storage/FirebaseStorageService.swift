//
// Created by Josh Freed on 2019-01-14.
// Copyright (c) 2019 Josh Freed. All rights reserved.
//

import Foundation
import FirebaseStorage
import SwiftyBeaver

class FirebaseStorageService {
    private let basePath: String?

    init(basePath: String? = nil) {
        self.basePath = basePath
    }

    private func reference() -> StorageReference {
        var storageRef = Storage.storage().reference()
        if let basePath = basePath {
            storageRef = storageRef.child(basePath)
        }
        return storageRef
    }

    func putData(_ data: Data, path: String) async throws -> URL {
        let storageRef = reference()
        let uploadRef = storageRef.child(path)

        return try await withCheckedThrowingContinuation { continuation in
            uploadRef.putData(data, metadata: nil) { (metadata, error) in
                if let err = error {
                    continuation.resume(with: .failure(err))
                    return
                }

                uploadRef.downloadURL { url, error1 in
                    if let error = error1 {
                        continuation.resume(with: .failure(error))
                    } else if let url = url {
                        continuation.resume(with: .success(url))
                    } else {
                        fatalError("Firebase downloadURL did not contain an error or url")
                    }
                }
            }
        }
    }

    func getData(path: String) async throws -> Data? {
        let maxSize: Int64 = 1 * 1024 * 1024
        let storageRef = reference()
        let pathReference = storageRef.child(path)

        return try await withCheckedThrowingContinuation { continuation in
            pathReference.getData(maxSize: maxSize) { data, error1 in
                if let error = error1 {
                    SwiftyBeaver.error("\(error)")
                    let errorCode = (error as NSError).code
                    guard let storageError = StorageErrorCode(rawValue: errorCode) else {
                        continuation.resume(with: .failure(error))
                        return
                    }
                    switch storageError {
                    case .objectNotFound: continuation.resume(with: .success(nil))
                    default: continuation.resume(with: .failure(error))
                    }
                } else {
                    continuation.resume(with: .success(data))
                }
            }
        }
    }
}

extension FirebaseStorageService: DataReadService {
    func getData(url: String) async throws -> Data? {
        SwiftyBeaver.debug("Getting data from firebase \(url)")
        return try await getData(path: url)
    }
}

extension FirebaseStorageService: DataWriteService {
    func putData(_ data: Data, url: String) async throws -> URL {
        SwiftyBeaver.debug("Putting data to firebase \(url)")
        return try await putData(data, path: url)
    }
}
