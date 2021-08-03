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

class MyAccountViewModel: ObservableObject {
    @Published var isLoaded = false
    @Published var fullName: String = ""
    @Published var emailAddress: String = ""
    @Published var profilePicture: UIImage?
    
    private let getMyAccountQuery: GetMyAccountQuery
    private let profilePictureWorker: ProfilePictureWorkerProtocol
    private let signOutCommand: SignOutCommand
    private var cancellable: AnyCancellable?
    private var editProfileViewModel: EditProfileViewModel?

    init() {
        SwiftyBeaver.debug("init")
        self.getMyAccountQuery = try! JFContainer.shared.container.resolve()
        self.profilePictureWorker = try! JFContainer.shared.container.resolve()
        self.signOutCommand = try! JFContainer.shared.container.resolve()
    }

    init(getMyAccountQuery: GetMyAccountQuery, profilePictureWorker: ProfilePictureWorkerProtocol, signOutCommand: SignOutCommand) {
        SwiftyBeaver.debug("init")
        self.getMyAccountQuery = getMyAccountQuery
        self.profilePictureWorker = profilePictureWorker
        self.signOutCommand = signOutCommand
    }
    
    deinit {
        SwiftyBeaver.debug("deinit")
        cancellable = nil
    }
    
    func loadMyAccount() {
        cancellable = getMyAccountQuery.getMyAccount()
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
                self?.fetchProfilePicture(url: value.profilePictureUrl)
            }
    }

    private func fetchProfilePicture(url: URL?) {
        Task {
            do {
                if let url = url, let data = try await profilePictureWorker.getProfilePicture(url: url) {
                    profilePicture = UIImage(data: data)
                } else {
                    profilePicture = nil
                }
            } catch {
                SwiftyBeaver.error("\(error)")
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }
    
    func signOut() {
        signOutCommand.signOut()
    }
}
