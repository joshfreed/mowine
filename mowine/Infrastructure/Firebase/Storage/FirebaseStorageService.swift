//
// Created by Josh Freed on 2019-01-14.
// Copyright (c) 2019 Josh Freed. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseStorageSwift
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
        let uploadRef = reference().child(path)
        _ = try await uploadRef.putDataAsync(data, metadata: nil)
        let url = try await uploadRef.downloadURL()
        return url
    }

    func getData(path: String) async throws -> Data {
        let maxSize: Int64 = 1 * 1024 * 1024
        let pathReference = reference().child(path)
        return try await pathReference.data(maxSize: maxSize)
    }
}

extension FirebaseStorageService: DataReadService {
    func getData(url: String) async throws -> Data {
        SwiftyBeaver.debug("Getting data from firebase \(url)")

        do {
            return try await getData(path: url)
        } catch {
            let errorCode = (error as NSError).code
            if StorageErrorCode(rawValue: errorCode) == .objectNotFound {
                throw DataReadServiceErrors.objectNotFound
            }
            throw error
        }
    }
}

extension FirebaseStorageService: DataWriteService {
    func putData(_ data: Data, url: String) async throws -> URL {
        SwiftyBeaver.debug("Putting data to firebase \(url)")
        return try await putData(data, path: url)
    }
}
