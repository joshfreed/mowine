//
//  EditProfileService.swift
//  mowine
//
//  Created by Josh Freed on 6/16/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import Foundation
import JFLib

class EditProfileService {
    let session: Session
    let userRepository: UserRepository
    let profilePictureWorker: ProfilePictureWorkerProtocol
    let userProfileService: UserProfileService

    private var newProfilePicture: UIImage?
    
    init(session: Session, userRepository: UserRepository, profilePictureWorker: ProfilePictureWorkerProtocol, userProfileService: UserProfileService) {
        self.session = session
        self.userRepository = userRepository
        self.profilePictureWorker = profilePictureWorker
        self.userProfileService = userProfileService
    }
    
    func fetchProfile(completion: @escaping (Result<ProfileViewModel>) -> ()) {
        session.getCurrentUser { result in
            switch result {
            case .success(let user): self.fetchProfileForUser(user, completion: completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func fetchProfileForUser(_ user: User, completion: @escaping (Result<ProfileViewModel>) -> ()) {
        let viewModel = ProfileViewModel(firstName: user.firstName, lastName: user.lastName, emailAddress: user.emailAddress)
        completion(.success(viewModel))
    }
    
    func getProfilePicture(completion: @escaping (Result<Data?>) -> ()) {
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
        if let newProfilePicture = newProfilePicture {
            profilePictureWorker.setProfilePicture(image: newProfilePicture) { result in
                switch result {
                case .success:
                    self.newProfilePicture = nil
                    self.updateUserProfile(email: email, firstName: firstName, lastName: lastName, completion: completion)
                case .failure(let error): completion(.failure(error))
                }
            }
        } else {
            updateUserProfile(email: email, firstName: firstName, lastName: lastName, completion: completion)
        }
    }
    
    private func updateUserProfile(email: String, firstName: String, lastName: String?, completion: @escaping (EmptyResult) -> ()) {
        session.getCurrentUser { result in
            switch result {
            case .success(let user): self.updateUserProfileObj(user, email: email, firstName: firstName, lastName: lastName, completion: completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    private func updateUserProfileObj(_ user: User, email: String, firstName: String, lastName: String?, completion: @escaping (EmptyResult) -> ()) {
        if user.emailAddress != email {
            userProfileService.updateEmailAddress(emailAddress: email) { result in
                switch result {
                case .success: self.updateUserProfile(firstName: firstName, lastName: lastName, completion: completion)
                case .failure(let error): completion(.failure(error))
                }
            }
        } else {
            updateUserProfile(firstName: firstName, lastName: lastName, completion: completion)
        }
    }
    
    private func updateUserProfile(firstName: String, lastName: String?, completion: @escaping (EmptyResult) -> ()) {
        let updateProfileRequest = UpdateUserProfileRequest(firstName: firstName, lastName: lastName)
        userProfileService.updateUserProfile(updateProfileRequest, completion: completion)
    }
    
    private func updateUserObj(_ user: User, email: String, firstName: String, lastName: String?, completion: @escaping (EmptyResult) -> ()) {
        var _user = user
        _user.emailAddress = email
        _user.firstName = firstName
        _user.lastName = lastName
        
        userRepository.save(user: _user) { result in
            switch result {
            case .success: completion(.success)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}

struct ProfileViewModel {
    var firstName: String?
    var lastName: String?
    var emailAddress: String
}
