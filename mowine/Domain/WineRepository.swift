//
//  WineRepository.swift
//  mowine
//
//  Created by Josh Freed on 2/21/18.
//  Copyright © 2018 BleepSmazz. All rights reserved.
//

import Foundation
import JFLib

protocol WineRepository {
    func getMyWines(completion: @escaping (Result<[Wine]>) -> ())
    func save(_ wine: Wine, completion: @escaping (Result<Wine>) -> ())
    func delete(_ wine: Wine, completion: @escaping (EmptyResult) -> ())
}
