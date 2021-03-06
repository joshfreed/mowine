//
//  DataHelpers.swift
//  mowine
//
//  Created by Josh Freed on 11/22/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import UIKit
import Model

extension MyAccountViewModel {
    static func make(fullName: String, email: String) -> MyAccountViewModel {
        let getMyAccountQuery = GetMyAccountQueryHandler(userRepository: FakeUserRepository(), session: FakeSession())
        let profilePictureWorker = FakeProfilePictureWorker()
        let signOutCommand = SignOutCommand(session: FakeSession())
        let vm = MyAccountViewModel(getMyAccountQuery: getMyAccountQuery, profilePictureWorker: profilePictureWorker, signOutCommand: signOutCommand)
        vm.fullName = fullName
        vm.emailAddress = email
        return vm
    }
    
    static func make() -> MyAccountViewModel {
        let getMyAccountQuery = GetMyAccountQueryHandler(userRepository: FakeUserRepository(), session: FakeSession())
        let profilePictureWorker = FakeProfilePictureWorker()
        let signOutCommand = SignOutCommand(session: FakeSession())
        let vm = MyAccountViewModel(getMyAccountQuery: getMyAccountQuery, profilePictureWorker: profilePictureWorker, signOutCommand: signOutCommand)
        vm.fullName = "Barry Jones"
        vm.emailAddress = "bjones@gmail.com"
        return vm
    }
}

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
            profilePictureWorker: profilePictureWorker,
            userProfileService: userProfileService,
            userRepository: FakeUserRepository()
        )
        let vm = EditProfileViewModel(getMyAccountQuery: getMyAccountQuery, profilePictureWorker: profilePictureWorker, editProfileService: editProfileService)
        vm.fullName = fullName
        vm.emailAddress = emailAddress
        return vm
    }
}

class FakeProfilePictureWorker: ProfilePictureWorkerProtocol {
    func setProfilePicture(image: UIImage, completion: @escaping (Result<Void, Error>) -> ()) {
        
    }
    
    func getProfilePicture(user: User, completion: @escaping (Result<Data?, Error>) -> ()) {
        
    }
    
    func getProfilePicture(url: URL, completion: @escaping (Result<Data?, Error>) -> ()) {
        
    }
}

extension EmailReauthViewModel {
    static func make(password: String? = nil, error: String? = nil) -> EmailReauthViewModel {
        let vm = EmailReauthViewModel(session: FakeSession()) {}
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
            .init(id: "1", name: "Barry Jones", profilePictureUrl: ""),
            .init(id: "2", name: "Mark Buffalo", profilePictureUrl: ""),
            .init(id: "3", name: "Hanky Panky", profilePictureUrl: ""),
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
