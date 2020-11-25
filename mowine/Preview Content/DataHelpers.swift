//
//  DataHelpers.swift
//  mowine
//
//  Created by Josh Freed on 11/22/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import UIKit

extension MyAccountViewModel {
    static func make(fullName: String, email: String) -> MyAccountViewModel {
        let getMyAccountQuery = GetMyAccountQuery(userRepository: FakeUserRepository(), session: FakeSession())
        let profilePictureWorker = FakeProfilePictureWorker()
        let signOutCommand = SignOutCommand(session: FakeSession())
        let vm = MyAccountViewModel(getMyAccountQuery: getMyAccountQuery, profilePictureWorker: profilePictureWorker, signOutCommand: signOutCommand)
        vm.fullName = fullName
        vm.emailAddress = email
        return vm
    }
    
    static func make() -> MyAccountViewModel {
        let getMyAccountQuery = GetMyAccountQuery(userRepository: FakeUserRepository(), session: FakeSession())
        let profilePictureWorker = FakeProfilePictureWorker()
        let signOutCommand = SignOutCommand(session: FakeSession())
        let vm = MyAccountViewModel(getMyAccountQuery: getMyAccountQuery, profilePictureWorker: profilePictureWorker, signOutCommand: signOutCommand)
        vm.fullName = "Barry Jones"
        vm.emailAddress = "bjones@gmail.com"
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
