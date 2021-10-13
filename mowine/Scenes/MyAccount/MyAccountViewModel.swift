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
import Model
import UIKit.UIImage

@MainActor
class MyAccountViewModel: ObservableObject {
    @Published var isLoaded = false
    @Published var fullName: String = ""
    @Published var emailAddress: String = ""
    @Published var profilePicture: UserPhoto = .url(nil)

    private let getMyAccountQuery: GetMyAccountQuery
    private let signOutCommand: SignOutCommand
    private var cancellable: AnyCancellable?
    private var editProfileViewModel: EditProfileViewModel?

    init() {
        SwiftyBeaver.debug("init")
        self.getMyAccountQuery = try! JFContainer.shared.resolve()
        self.signOutCommand = try! JFContainer.shared.resolve()
    }

    init(getMyAccountQuery: GetMyAccountQuery, signOutCommand: SignOutCommand) {
        SwiftyBeaver.debug("init")
        self.getMyAccountQuery = getMyAccountQuery
        self.signOutCommand = signOutCommand
    }
    
    deinit {
        SwiftyBeaver.debug("deinit")
        cancellable = nil
    }
    
    func loadMyAccount() {
        cancellable = getMyAccountQuery.getMyAccountAndListen()
            .compactMap { $0 }
            .sink { completion in
                SwiftyBeaver.info("\(completion)")
                if case let .failure(error) = completion {
                    SwiftyBeaver.error("\(error)")
                    Crashlytics.crashlytics().record(error: error)
                }
            } receiveValue: { [weak self] value in
                self?.isLoaded = true
                self?.fullName = value.fullName
                self?.emailAddress = value.emailAddress
                self?.profilePicture = .url(value.profilePictureUrl)
            }
    }

    func signOut() {
        signOutCommand.signOut()
    }
}
