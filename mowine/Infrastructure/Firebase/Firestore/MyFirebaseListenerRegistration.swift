//
//  MyFirebaseListenerRegistration.swift
//  mowine
//
//  Created by Josh Freed on 11/12/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Model
import MoWine_Domain

class MyFirebaseListenerRegistration: MoWineListenerRegistration {
    let wrapped: ListenerRegistration

    init(wrapped: ListenerRegistration) {
        self.wrapped = wrapped
    }

    func remove() {
        wrapped.remove()
    }
}
