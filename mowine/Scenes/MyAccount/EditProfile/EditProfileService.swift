//
//  EditProfileService.swift
//  mowine
//
//  Created by Josh Freed on 6/16/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import Foundation
import JFLib
import PromiseKit

class EditProfileService {
    let session: Session
    let profilePictureWorker: ProfilePictureWorkerProtocol
    let userProfileService: UserProfileService

    private(set) var newProfilePicture: UIImage?
    
    init(session: Session, profilePictureWorker: ProfilePictureWorkerProtocol, userProfileService: UserProfileService) {
        self.session = session
        self.profilePictureWorker = profilePictureWorker
        self.userProfileService = userProfileService
    }
    
    func fetchProfile(completion: @escaping (JFLib.Result<ProfileViewModel>) -> ()) {
        session.getCurrentUser { result in
            switch result {
            case .success(let user): self.fetchProfileForUser(user, completion: completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func fetchProfileForUser(_ user: User, completion: @escaping (JFLib.Result<ProfileViewModel>) -> ()) {
        let viewModel = ProfileViewModel(firstName: user.firstName, lastName: user.lastName, emailAddress: user.emailAddress)
        completion(.success(viewModel))
    }
    
    func getProfilePicture(completion: @escaping (JFLib.Result<Data?>) -> ()) {
        session.getCurrentUser { result in
            switch result {
            case .success(let user): self.profilePictureWorker.getProfilePicture(user: user, completion: completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func updateProfilePicture(_ image: UIImage) {
        newProfilePicture = image
    }
    
    func saveProfile(email: String, firstName: String, lastName: String?, completion: @escaping (EmptyResult) -> ()) {
        firstly {
            userProfileService.updateProfilePicture(newProfilePicture)
        }.get {
            self.newProfilePicture = nil
        }.then {
            self.userProfileService.updateEmailAddress(emailAddress: email)
        }.then {
            self.userProfileService.updateUserProfile(
                UpdateUserProfileRequest(firstName: firstName, lastName: lastName)
            )
        }.done {
            completion(.success)
        }.catch { error in
            completion(.failure(error))
        }
    }    
}

struct ProfileViewModel {
    var firstName: String?
    var lastName: String?
    var emailAddress: String
}
