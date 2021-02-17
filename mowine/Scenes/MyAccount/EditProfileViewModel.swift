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

    var closeModal: (() -> Void)?

    private let getMyAccountQuery: GetMyAccountQuery
    private let profilePictureWorker: ProfilePictureWorkerProtocol
    private let editProfileService: EditProfileService
    private var hasChanges = false

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

    func loadProfile() {
        getMyAccountQuery.getMyAccount { [weak self] result in
            switch result {
            case .success(let profile):
                self?.setProfile(profile)
                self?.fetchProfilePicture(url: profile.profilePictureUrl)
                self?.hasChanges = false
            case .failure(let error):
                SwiftyBeaver.error("\(error)")
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }
    
    private func setProfile(_ profile: GetMyAccountQueryResponse) {
        fullName = profile.fullName
        emailAddress = profile.emailAddress
    }

    private func fetchProfilePicture(url: URL?) {
        if let url = url {
            profilePictureWorker.getProfilePicture(url: url) { [weak self] result in
                switch result {
                case .success(let data):
                    if let data = data {
                        self?.profilePicture = UIImage(data: data)
                    }
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
    
    private func profileDidChange() {
        hasChanges = true
    }
    
    func saveProfile() {
        if !hasChanges {
            closeModal?()
            return
        }
        
        isSaving = true

        editProfileService.saveProfile(email: emailAddress, fullName: fullName) { [weak self] result in
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
                reauthenticate()
            } else {
                SwiftyBeaver.error("\(error)")
                showErrorAlert = true
                saveErrorMessage = error.localizedDescription
            }
        }
    }
    
    func reauthenticate() {
        isReauthenticating = true
        isShowingSheet = true
    }
    
    func reauthenticationSuccess() {
        isReauthenticating = false
        isShowingSheet = false
        saveProfile()
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
