//
//  WineType.swift
//  mowine
//
//  Created by Josh Freed on 2/21/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation

struct WineType: Equatable {
    var name: String
    var varieties: [WineVariety] = []
    
    static func ==(lhs: WineType, rhs: WineType) -> Bool {
        return lhs.name == rhs.name
    }
    
    func getVariety(named name: String) -> WineVariety? {
        return varieties.first(where: { $0.name == name })
    }
}
