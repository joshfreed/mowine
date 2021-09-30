//
//  Listener.swift
//  mowine
//
//  Created by Josh Freed on 6/19/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import Foundation

public protocol MoWineListenerRegistration {
    func remove()
}

public class FakeRegistration: MoWineListenerRegistration {
    public init() {}

    public func remove() {}
}
