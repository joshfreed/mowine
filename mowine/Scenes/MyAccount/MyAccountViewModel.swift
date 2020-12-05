//
//  MyAccountViewModel.swift
//  mowine
//
//  Created by Josh Freed on 11/21/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation
import SwiftyBeaver
import Combine
import FirebaseCrashlytics

class MyAccountViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var emailAddress: String = ""
    @Published var profilePicture: Data?
    
    let getMyAccountQuery: GetMyAccountQuery
    let profilePictureWorker: ProfilePictureWorkerProtocol
    let signOutCommand: SignOutCommand
    private var cancellable: AnyCancellable?
    
    init(getMyAccountQuery: GetMyAccountQuery, profilePictureWorker: ProfilePictureWorkerProtocol, signOutCommand: SignOutCommand) {
        SwiftyBeaver.debug("init")
        self.getMyAccountQuery = getMyAccountQuery
        self.profilePictureWorker = profilePictureWorker
        self.signOutCommand = signOutCommand
    }
    
    func loadMyAccount() {
        cancellable = getMyAccountQuery.getMyAccount().sink { completion in
            SwiftyBeaver.info("\(completion)")
            if case let .failure(error) = completion {
                SwiftyBeaver.error("\(error)")
                Crashlytics.crashlytics().record(error: error)
            }
        } receiveValue: { [weak self] value in
            self?.fullName = value.fullName
            self?.emailAddress = value.emailAddress
            self?.fetchProfilePicture(url: value.profilePictureUrl)
        }
    }
    
    private func fetchProfilePicture(url: URL?) {
        if let url = url {
            profilePictureWorker.getProfilePicture(url: url) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data): self?.profilePicture = data
                    case .failure(let error):
                        SwiftyBeaver.error("\(error)")
                        Crashlytics.crashlytics().record(error: error)
                    }
                }
            }
        } else {
            profilePicture = nil
        }
    }
    
    func signOut() {
        signOutCommand.signOut()
    }
}
