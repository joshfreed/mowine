//
//  WineType.swift
//  mowine
//
//  Created by Josh Freed on 2/21/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation

public struct WineType: Equatable, Hashable, Identifiable {
    public var id: Int { hashValue }
    public var name: String
    public var varieties: [WineVariety] = []

    public init(name: String, varieties: [WineVariety] = []) {
        self.name = name
        self.varieties = varieties
    }

    public static func ==(lhs: WineType, rhs: WineType) -> Bool {
        return lhs.name == rhs.name
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    public func getVariety(named name: String) -> WineVariety? {
        return varieties.first(where: { $0.name == name })
    }
}
