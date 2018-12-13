//
//  WineImageRepository.swift
//  mowine
//
//  Created by Josh Freed on 4/10/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib

protocol WineImageRepository {
    func store(wineId: WineId, image: Data, thumbnail: Data)
    func fetchThumbnail(wineId: WineId, userId: UserId, completion: @escaping (Result<Data?>) -> ())
    func fetchPhoto(wineId: WineId, completion: @escaping (Result<Data?>) -> ())
    func deleteImages(wineId: WineId)
}
