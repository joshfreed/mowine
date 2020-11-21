//
// Created by Josh Freed on 2019-04-12.
// Copyright (c) 2019 Josh Freed. All rights reserved.
//

import Foundation
import SwiftyBeaver

class UrlSessionService {
    //
    // Helper method wrapping URLSession.shared.dataTask that returns a Result object with optional Data
    //
    func dataTask(with url: URL, completion: @escaping (Result<Data?, Error>) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(data))
            }
        }
        task.resume()
    }
}

extension UrlSessionService: DataReadService {
    func getData(url: URL, completion: @escaping (Result<Data?, Error>) -> ()) {
        SwiftyBeaver.debug("Getting data from URL session \(url)")
        dataTask(with: url, completion: completion)
    }
}
