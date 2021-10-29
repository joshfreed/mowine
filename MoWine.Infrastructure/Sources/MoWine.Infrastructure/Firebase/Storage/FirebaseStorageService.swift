//
// Created by Josh Freed on 2019-01-14.
// Copyright (c) 2019 Josh Freed. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseStorageSwift
import SwiftyBeaver
import MoWine_Application
import MoWine_Domain

public class FirebaseStorageService {
    private let basePath: String?

    public init(basePath: String? = nil) {
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

public class FirebaseWineImageStorage: WineImageStorage {
    private let storage: FirebaseStorageService
    private let session: Session

    public init(storage: FirebaseStorageService, session: Session) {
        self.storage = storage
        self.session = session
    }

    public func putImage(wineId: WineId, size: WineImageSize, data: Data) async throws {
        guard let userId = session.currentUserId else { throw SessionError.notLoggedIn }

        let path: String
        switch size {
        case .thumbnail: path = "\(userId)/\(wineId)-thumb.png"
        case .full: path = "\(userId)/\(wineId).png"
        }

        _ = try await storage.putData(data, path: path)
    }

    public func getImage(wineId: WineId, size: WineImageSize) async throws -> Data {
        guard let userId = session.currentUserId else { throw SessionError.notLoggedIn }

        let path: String
        switch size {
        case .thumbnail: path = "\(userId)/\(wineId)-thumb.png"
        case .full: path = "\(userId)/\(wineId).png"
        }

        do {
            return try await storage.getData(path: path)
        } catch {
            let errorCode = (error as NSError).code
            if StorageErrorCode(rawValue: errorCode) == .objectNotFound {
                throw WineImageStorageErrors.imageNotFound
            }
            throw error
        }
    }
}

public class FirebaseUserImageStorage: UserImageStorage {
    private let storage: FirebaseStorageService

    public init(storage: FirebaseStorageService) {
        self.storage = storage
    }

    public func putImage(userId: UserId, data: Data) async throws -> URL {
        let path = "\(userId)/profile.png"
        return try await storage.putData(data, path: path)
    }
}
