//
//  FakeWineThumbnailFetcher.swift
//  mowine
//
//  Created by Josh Freed on 10/17/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation
import JFLib

class FakeWineThumbnailFetcher: WineListThumbnailFetcher {
    func fetchThumbnail(for wineId: String, completion: @escaping (Result<Data?>) -> ()) {
        completion(.success(nil))
    }

    func fetchThumbnail(for wine: Wine,  completion: @escaping (Result<Data?>) -> ()) {
        completion(.success(nil))
    }
}
