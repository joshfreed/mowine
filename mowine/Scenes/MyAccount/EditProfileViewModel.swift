//
//  EditProfileViewModel.swift
//  mowine
//
//  Created by Josh Freed on 11/25/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import FirebaseCrashlytics
import SwiftyBeaver

class EditProfileViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var emailAddress: String = ""
    @Published var profilePicture: Data?
    @Published var isSaving = false
    @Published var showErrorAlert = false
    @Published var saveErrorMessage: String = ""
    @Published var isReauthenticating = false

    var closeModal: (() -> Void)?

    private let getMyAccountQuery: GetMyAccountQuery
    private let profilePictureWorker: ProfilePictureWorkerProtocol
    private let editProfileService: EditProfileService

    init(
        getMyAccountQuery: GetMyAccountQuery,
        profilePictureWorker: ProfilePictureWorkerProtocol,
        editProfileService: EditProfileService
    ) {
        self.getMyAccountQuery = getMyAccountQuery
        self.profilePictureWorker = profilePictureWorker
        self.editProfileService = editProfileService
    }

    func loadProfile() {
        getMyAccountQuery.getMyAccount { [weak self] result in
            switch result {
            case .success(let profile):
                self?.firstName = profile.firstName ?? ""
                self?.lastName = profile.lastName ?? ""
                self?.emailAddress = profile.emailAddress
                self?.fetchProfilePicture(url: profile.profilePictureUrl)
            case .failure(let error):
                SwiftyBeaver.error("\(error)")
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }

    private func fetchProfilePicture(url: URL?) {
        if let url = url {
            profilePictureWorker.getProfilePicture(url: url) { [weak self] result in
                switch result {
                case .success(let data): self?.profilePicture = data
                case .failure(let error):
                    SwiftyBeaver.error("\(error)")
                    Crashlytics.crashlytics().record(error: error)
                }
            }
        } else {
            profilePicture = nil
        }
    }

    func cancel() {
        closeModal?()
    }

    func saveProfile() {
        SwiftyBeaver.info("Saving profile...")

        isSaving = true

        editProfileService.saveProfile(email: emailAddress, firstName: firstName, lastName: lastName) { [weak self] result in
            SwiftyBeaver.info("Save profile complete")
            self?.isSaving = false
            self?.saveProfileCallback(result: result)
        }
    }

    private func saveProfileCallback(result: Result<Void, Error>) {
        switch result {
        case .success:
            closeModal?()
        case .failure(let error):
            if case SessionError.requiresRecentLogin = error {
                isReauthenticating = true
            } else {
                SwiftyBeaver.error("\(error)")
                showErrorAlert = true
                saveErrorMessage = error.localizedDescription
            }
        }
    }
}

extension EditProfileViewModel {
    enum State {
        case editing
        case saving
        case reauthenticate
        case saveError(Error)
    }
}

extension EditProfileViewModel {
    static func factory(onClose: @escaping () -> Void) -> EditProfileViewModel {
        let getMyAccountQuery = GetMyAccountQueryHandler(
            userRepository: JFContainer.shared.userRepository,
            session: JFContainer.shared.session
        )
        let profilePictureWorker: ProfilePictureWorkerProtocol = try! JFContainer.shared.container.resolve()
        let editProfileService: EditProfileService = try! JFContainer.shared.container.resolve()
        let vm = EditProfileViewModel(
            getMyAccountQuery: getMyAccountQuery,
            profilePictureWorker: profilePictureWorker,
            editProfileService: editProfileService
        )
        vm.closeModal = onClose
        return vm
    }
}