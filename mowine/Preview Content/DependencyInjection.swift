//
//  PreviewServices.swift
//  mowine
//
//  Created by Josh Freed on 10/21/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Dip
import MoWine_Application
import MoWine_Domain
import MoWine_Infrastructure

class PreviewServices {
    static func registerServices(container: DependencyContainer) {
        container.register(.singleton) { FakeSession() }.implements(Session.self)
        container.register(.singleton) { FakeEmailAuth() as EmailAuthenticationService }
        container.register(.singleton) { MemoryUserRepository() }.implements(UserRepository.self)
        container.register(.singleton) { MemoryWineRepository() as WineRepository }
        container.register(.singleton) { FakeSocialAuth() as SocialAuthService }
        container.register { AssetWineImageStorage(wineRepository: $0) }.implements(WineImageStorage.self)
        container.register { FakeUserImageStorage() }.implements(UserImageStorage.self)
    }
}
