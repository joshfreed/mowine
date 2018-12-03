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
    func store(wineId: UUID, image: Data, thumbnail: Data)
    func fetchThumbnail(wineId: UUID, userId: UserId, completion: @escaping (Result<Data?>) -> ())
    func fetchPhoto(wineId: UUID, completion: @escaping (Result<Data?>) -> ())
    func deleteImages(wineId: UUID)
}
