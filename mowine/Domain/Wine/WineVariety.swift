//
//  WineVariety.swift
//  mowine
//
//  Created by Josh Freed on 2/21/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation

struct WineVariety: Equatable, Hashable, Identifiable {
    var id: Int { hashValue }
    var name: String
    
    public static func ==(lhs: WineVariety, rhs: WineVariety) -> Bool {
        return lhs.name == rhs.name
    }
}
