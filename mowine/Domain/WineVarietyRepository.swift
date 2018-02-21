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
    func getVarieties(of type: WineType, completion: @escaping (Result<[WineVariety]>) -> ())
    func getVariety(named name: String, completion: @escaping (Result<WineVariety>) -> ())
}
