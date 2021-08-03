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
import Model
import UIKit.UIImage

class EditProfileViewModel: ObservableObject {
    @Published var fullName: String = "" {
        didSet {
            profileDidChange()
        }
    }
    @Published var emailAddress: String = "" {
        didSet {
            profileDidChange()
        }
    }
    @Published var profilePicture: UIImage?
    @Published var isSaving = false
    @Published var showErrorAlert = false
    @Published var saveErrorMessage: String = ""
    @Published var isShowingSheet = false
    @Published var isPickingImage = false
    @Published var pickerSourceType: ImagePickerView.SourceType = .camera
    @Published var isReauthenticating = false

    private let getMyAccountQuery: GetMyAccountQuery
    private let profilePictureWorker: ProfilePictureWorkerProtocol
    private let editProfileService: EditProfileService
    private var hasChanges = false

    init() {
        SwiftyBeaver.debug("init")
        self.getMyAccountQuery = try! JFContainer.shared.container.resolve()
        self.profilePictureWorker = try! JFContainer.shared.container.resolve()
        self.editProfileService = try! JFContainer.shared.container.resolve()
    }

    init(
        getMyAccountQuery: GetMyAccountQuery,
        profilePictureWorker: ProfilePictureWorkerProtocol,
        editProfileService: EditProfileService
    ) {
        SwiftyBeaver.debug("init")
        self.getMyAccountQuery = getMyAccountQuery
        self.profilePictureWorker = profilePictureWorker
        self.editProfileService = editProfileService
    }
    
    deinit {
        SwiftyBeaver.debug("deinit")
    }

    func loadProfile() async {
        do {
            let profile = try await getMyAccountQuery.getMyAccount()!
            setProfile(profile)
            try await fetchProfilePicture(url: profile.profilePictureUrl)
            hasChanges = false
        } catch {
            SwiftyBeaver.error("\(error)")
            Crashlytics.crashlytics().record(error: error)
        }
    }
    
    private func setProfile(_ profile: GetMyAccountQueryResponse) {
        fullName = profile.fullName
        emailAddress = profile.emailAddress
    }

    private func fetchProfilePicture(url: URL?) async throws {
        if let url = url, let data = try await profilePictureWorker.getProfilePicture(url: url) {
            profilePicture = UIImage(data: data)
        } else {
            profilePicture = nil
        }
    }

    private func profileDidChange() {
        hasChanges = true
    }
    
    func saveProfile() async {
        if !hasChanges {
            return
        }

        isSaving = true

        do {
            try await editProfileService.saveProfile(email: emailAddress, fullName: fullName)
            isSaving = false
        } catch {
            isSaving = false
            if case SessionError.requiresRecentLogin = error {
                reauthenticate()
            } else {
                SwiftyBeaver.error("\(error)")
                Crashlytics.crashlytics().record(error: error)
                showErrorAlert = true
                saveErrorMessage = error.localizedDescription
            }
        }
    }

    func reauthenticate() {
        isReauthenticating = true
        isShowingSheet = true
    }
    
    func reauthenticationSuccess() async {
        isReauthenticating = false
        isShowingSheet = false
        await saveProfile()
    }
    
    func selectProfilePicture(from sourceType: ImagePickerView.SourceType) {
        isPickingImage = true
        pickerSourceType = sourceType
        isShowingSheet = true
    }
    
    func changeProfilePicture(to image: UIImage) {
        editProfileService.updateProfilePicture(image)
        profilePicture = image
        isShowingSheet = false
        profileDidChange()
    }
    
    func cancelSelectProfilePicture() {
        isPickingImage = false
        isShowingSheet = false
    }
}
