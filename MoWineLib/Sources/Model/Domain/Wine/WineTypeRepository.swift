//
//  WineTypeRepository.swift
//  mowine
//
//  Created by Josh Freed on 2/20/18.
//  Copyright © 2018 BleepSmazz. All rights reserved.
//

import Foundation

public protocol WineTypeRepository {
    func getAll(completion: @escaping (Result<[WineType], Error>) -> ())
    func getWineType(named name: String, completion: @escaping (Result<WineType?, Error>) -> ())
}
