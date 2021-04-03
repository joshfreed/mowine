//
//  WineListThumbnailFetcher.swift
//  mowine
//
//  Created by Josh Freed on 4/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation

protocol WineListThumbnailFetcher: class {
    func fetchThumbnail(for wineId: String, completion: @escaping (Result<Data?, Error>) -> ())
    func fetchThumbnail(for wine: Wine, completion: @escaping (Result<Data?, Error>) -> ())
}
