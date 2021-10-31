//
//  DataHelpers.swift
//  mowine
//
//  Created by Josh Freed on 11/22/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import UIKit
import MoWine_Application
import MoWine_Domain
import MoWine_Infrastructure

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

extension UsersService {
    static func make() -> UsersService {
        UsersService(session: FakeSession(), userRepository: MemoryUserRepository())
    }
}

#endif
