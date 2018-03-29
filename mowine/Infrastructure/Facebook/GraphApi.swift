//
//  GraphApi.swift
//  mowine
//
//  Created by Josh Freed on 3/29/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib
import FBSDKLoginKit

enum GraphApiError: Error {
    case unknownError
}

class GraphApi {
    func me(params: [String: String], completion: @escaping (Result<[String: Any]>) -> ()) {
        let request = FBSDKGraphRequest(graphPath: "me", parameters: params)
        _ = request?.start { connection, result, error in
            if let e = error {
                let error = e as NSError
                print("\(error)")
                completion(.failure(error))
            } else if let result = result as? [String: Any] {
                completion(.success(result))
            } else {
                print("RESULT: \(String(describing: result))")
                print("ERROR: \(String(describing: error))")
                completion(.failure(GraphApiError.unknownError))
            }
        }
    }
}
