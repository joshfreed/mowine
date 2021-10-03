//
//  DataHelpers.swift
//  mowine
//
//  Created by Josh Freed on 11/22/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import UIKit
import Model

extension EditProfileViewModel {
    static func make() -> EditProfileViewModel {
        .make(emailAddress: "", fullName: "Barry Jones")
    }
    
    static func make(emailAddress: String, fullName: String) -> EditProfileViewModel {
        let getMyAccountQuery = GetMyAccountQueryHandler(userRepository: FakeUserRepository(), session: FakeSession())
        let profilePictureWorker = FakeProfilePictureWorker()
        let userProfileService = UserProfileService(session: FakeSession(), userRepository: FakeUserRepository(), profilePictureWorker: profilePictureWorker)
        let editProfileService = EditProfileService(
            session: FakeSession(),
            userProfileService: userProfileService,
            userRepository: FakeUserRepository()
        )
        let vm = EditProfileViewModel(getMyAccountQuery: getMyAccountQuery, editProfileService: editProfileService)
        vm.fullName = fullName
        vm.emailAddress = emailAddress
        return vm
    }
}

class FakeProfilePictureWorker: ProfilePictureWorkerProtocol {
    func setProfilePicture(image: UIImage) async throws {}
}

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
        let service = FriendsService(session: FakeSession(), userRepository: FakeUserRepository())
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
        let service = UsersService(session: FakeSession(), userRepository: FakeUserRepository())
        return service
    }
}

extension GetTopWinesQuery {
    static func make() -> GetTopWinesQuery {
        GetTopWinesQuery(wineRepository: MemoryWineRepository())
    }
}
