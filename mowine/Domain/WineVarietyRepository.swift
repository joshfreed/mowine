//
//  WineVarietyRepository.swift
//  mowine
//
//  Created by Josh Freed on 2/20/18.
//  Copyright © 2018 BleepSmazz. All rights reserved.
//

import Foundation
import JFLib

protocol WineVarietyRepository {
    func getVariety(named name: String, completion: @escaping (Result<WineVariety>) -> ())
}

enum WineVarietyRepositoryError: Error {
    case notFound
}
