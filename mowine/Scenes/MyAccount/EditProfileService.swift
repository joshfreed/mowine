//
//  EditProfileService.swift
//  mowine
//
//  Created by Josh Freed on 6/16/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import UIKit
import Model
import Combine

class EditProfileService {
    let session: Session
    let profilePictureWorker: ProfilePictureWorkerProtocol
    let userProfileService: UserProfileService
    let userRepository: UserRepository

    private(set) var newProfilePicture: UIImage?

    private var cancellable: AnyCancellable?
    
    init(session: Session, profilePictureWorker: ProfilePictureWorkerProtocol, userProfileService: UserProfileService, userRepository: UserRepository) {
        self.session = session
        self.profilePictureWorker = profilePictureWorker
        self.userProfileService = userProfileService
        self.userRepository = userRepository
    }
    
    func fetchProfile(completion: @escaping (Swift.Result<ProfileViewModel, Error>) -> ()) {
        getCurrentUser { result in
            switch result {
            case .success(let user): self.presentUserProfile(user, completion: completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func presentUserProfile(_ user: User, completion: @escaping (Swift.Result<ProfileViewModel, Error>) -> ()) {
        let viewModel = ProfileViewModel(fullName: user.fullName, emailAddress: user.emailAddress)
        completion(.success(viewModel))
    }
    
    func getProfilePicture(completion: @escaping (Swift.Result<Data?, Error>) -> ()) {
        getCurrentUser { result in
            switch result {
            case .success(let user): self.profilePictureWorker.getProfilePicture(user: user, completion: completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func updateProfilePicture(_ image: UIImage) {
        newProfilePicture = image
    }
    
    func saveProfile(email: String, fullName: String, completion: @escaping (Swift.Result<Void, Error>) -> ()) {
        cancellable = userProfileService
            .updateProfilePicture(newProfilePicture)
            .handleEvents(receiveOutput: { [weak self] in self?.newProfilePicture = nil })
            .compactMap { [weak self] in self?.userProfileService.updateEmailAddress(emailAddress: email) }
            .switchToLatest()
            .compactMap { [weak self] in self?.userProfileService.updateUserProfile(.init(fullName: fullName)) }
            .switchToLatest()
            .sink { compl in
                switch compl {
                case .finished: completion(.success(()))
                case .failure(let error): completion(.failure(error))
                }
            } receiveValue: {

            }
    }
    
    private func getCurrentUser(completion: @escaping (Swift.Result<User, Error>) -> ()) {
        guard let currentUserId = session.currentUserId else {
            completion(.failure(SessionError.notLoggedIn))
            return
        }

        userRepository.getUserById(currentUserId) { result in
            switch result {
            case .success(let user):
                if let user = user {
                    completion(.success(user))
                } else {
                    completion(.failure(UserRepositoryError.userNotFound))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }        
    }
}

struct ProfileViewModel {
    var fullName: String
    var emailAddress: String
}
