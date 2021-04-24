//
//  WineVariety.swift
//  mowine
//
//  Created by Josh Freed on 2/21/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation

public struct WineVariety: Equatable, Hashable, Identifiable {
    public var id: Int { hashValue }
    public var name: String

    public init(name: String) {
        self.name = name
    }

    public static func ==(lhs: WineVariety, rhs: WineVariety) -> Bool {
        return lhs.name == rhs.name
    }
}
