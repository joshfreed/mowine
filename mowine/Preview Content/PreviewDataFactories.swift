//
//  DataHelpers.swift
//  mowine
//
//  Created by Josh Freed on 11/22/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import UIKit
import Model
import MoWine_Domain

#if DEBUG

extension EmailReauthViewModel {
    static func make(password: String? = nil, error: String? = nil) -> EmailReauthViewModel {
        let vm = EmailReauthViewModel()
        if let password = password {
            vm.password = password
        }
        if let error = error {
            vm.error = error
        }
        return vm
    }
}

extension FriendsService {
    static func make() -> FriendsService {
        let service = FriendsService(session: FakeSession(), userRepository: MemoryUserRepository())
        service.friends = [
            .init(id: "1", name: "Barry Jones", profilePictureUrl: nil),
            .init(id: "2", name: "Mark Buffalo", profilePictureUrl: nil),
            .init(id: "3", name: "Hanky Panky", profilePictureUrl: nil),
        ]
        return service
    }
}

extension UsersService {
    static func make() -> UsersService {
        UsersService(session: FakeSession(), userRepository: MemoryUserRepository())
    }
}

#endif
