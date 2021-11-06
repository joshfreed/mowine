//
//  EditProfileViewModel.swift
//  mowine
//
//  Created by Josh Freed on 11/25/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import SwiftyBeaver
import MoWine_Application
import UIKit.UIImage

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
    @Published var showErrorAlert = false
    @Published var saveErrorMessage: String = ""
    @Published var isReauthenticating = false

    @Injected private var getMyAccountQuery: GetMyAccountQuery
    @Injected private var updateProfileCommandHandler: UpdateProfileCommandHandler

    private var hasChanges = false

    private var newProfilePicture: UIImage? {
        if case let .uiImage(image) = profilePicture {
            return image
        } else {
            return nil
        }
    }

    init() {
        SwiftyBeaver.debug("init")
    }

    deinit {
        SwiftyBeaver.debug("deinit")
    }

    func loadProfile() async {
        do {
            guard let profile = try await getMyAccountQuery.getMyAccount() else {
                return
            }
            setProfile(profile)
            hasChanges = false
        } catch {
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
    
    func saveProfile() async {
        guard hasChanges else {
            return
        }

        isSaving = true

        do {
            let command = UpdateProfileCommand(email: emailAddress, fullName: fullName, image: newProfilePicture?.pngData())
            try await updateProfileCommandHandler.handle(command)
            isSaving = false
        } catch {
            isSaving = false
            if case SessionError.requiresRecentLogin = error {
                reauthenticate()
            } else {
                CrashReporter.shared.record(error: error)
                showErrorAlert = true
                saveErrorMessage = error.localizedDescription
            }
        }
    }

    func reauthenticate() {
        isReauthenticating = true
    }
    
    func reauthenticationSuccess() async {
        isReauthenticating = false
        await saveProfile()
    }
}
