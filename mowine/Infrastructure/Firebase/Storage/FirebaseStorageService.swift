//
// Created by Josh Freed on 2019-01-14.
// Copyright (c) 2019 Josh Freed. All rights reserved.
//

import Foundation
import JFLib
import FirebaseStorage
import SwiftyBeaver

class FirebaseStorageService {
    let storage: Storage

    init() {
        storage = Storage.storage()
    }

    func putData(_ data: Data, path: String) {
        let storageRef = storage.reference()
        storageRef.child(path).putData(data)
    }

    func getData(path: String, completion: @escaping (Result<Data?>) -> ()) {
        let maxSize: Int64 = 1 * 1024 * 1024
        let pathReference = storage.reference(withPath: path)

        pathReference.getData(maxSize: maxSize) { data, error in
            if let error = error {
                SwiftyBeaver.error("\(error)")
                completion(.failure(error))
            } else {
                completion(.success(data))
            }
        }
    }
}