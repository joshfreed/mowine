//
//  Listener.swift
//  mowine
//
//  Created by Josh Freed on 6/19/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import Foundation

protocol MoWineListenerRegistration {
    func remove()
}

class FakeRegistration: MoWineListenerRegistration {
    func remove() {
        
    }
}
