//
//  EditProfileViewModel.swift
//  mowine
//
//  Created by Josh Freed on 11/25/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Combine
import JFLib_Mediator
import MoWine_Application
import OSLog

@MainActor
class EditProfileViewModel: ObservableObject {
    @Published var fullName: String = "" {
        didSet {
            if oldValue != fullName {
                profileDidChange()
            }
        }
    }
    @Published var emailAddress: String = "" {
        didSet {
            if oldValue != emailAddress {
                profileDidChange()
            }
        }
    }
    @Published var profilePicture: UserPhoto = .url(nil) {
        didSet {
            profileDidChange()
        }
    }

    @Published var isSaving = false
    @Published var isDeleting = false
    @Published var showErrorAlert = false
    @Published var saveErrorMessage: String = ""
    @Injected private var mediator: Mediator
    @Injected private var updateProfileCommandHandler: UpdateProfileCommandHandler
    @Injected private var deleteAccountService: DeleteAccountService

    private let logger = Logger(category: .ui)
    private var hasChanges = false

    private var newProfilePicture: UIImage? {
        if case let .uiImage(image) = profilePicture {
            return image
        } else {
            return nil
        }
    }

    func loadProfile() async {
        do {
            guard let profile: GetMyAccountQueryResponse = try await mediator.send(GetMyAccountQuery()) else {
                return
            }
            setProfile(profile)
            hasChanges = false
        } catch {
            logger.error("\(error)")
            CrashReporter.shared.record(error: error)
        }
    }
    
    private func setProfile(_ profile: GetMyAccountQueryResponse) {
        fullName = profile.fullName
        emailAddress = profile.emailAddress
        profilePicture = .url(profile.profilePictureUrl)
    }

    private func profileDidChange() {
        hasChanges = true
    }

    func saveProfile(using reauth: ReauthenticationController) async -> Bool {
        guard hasChanges else { return true }
        isSaving = true
        defer { isSaving = false }

        do {
            let command = UpdateProfileCommand(email: emailAddress, fullName: fullName, image: newProfilePicture?.pngData())
            try await reauth.withReauthenticationRetry {
                try await self.updateProfileCommandHandler.handle(command)
            }
            hasChanges = false
            return true
        } catch is CancellationError {
            return false
        } catch {
            logger.error("\(error)")
            CrashReporter.shared.record(error: error)
            showErrorAlert = true
            saveErrorMessage = error.localizedDescription
            return false
        }
    }

    func deleteAccount(using reauth: ReauthenticationController) async -> Bool {
        isDeleting = true
        defer { isDeleting = false }

        do {
            try await reauth.withReauthenticationRetry {
                try await self.deleteAccountService.deleteAccount()
            }
            return true
        } catch is CancellationError {
            return false
        } catch {
            logger.error("\(error)")
            CrashReporter.shared.record(error: error)
            showErrorAlert = true
            saveErrorMessage = error.localizedDescription
            return false
        }
    }
}
