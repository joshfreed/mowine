//
//  EditProfileService.swift
//  mowine
//
//  Created by Josh Freed on 6/16/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import Foundation

class EditProfileService {
    let session: Session
    let userRepository: UserRepository
    
    init(session: Session, userRepository: UserRepository) {
        self.session = session
        self.userRepository = userRepository
    }
    
    func fetchProfile(completion: @escaping (Result<ProfileViewModel, Error>) -> ()) {
        session.getCurrentUser { result in
            switch result {
            case .success(let user): self.fetchProfileForUser(user, completion: completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func fetchProfileForUser(_ user: User, completion: @escaping (Result<ProfileViewModel, Error>) -> ()) {
        let viewModel = ProfileViewModel(firstName: user.firstName, lastName: user.lastName, emailAddress: user.emailAddress)
        completion(.success(viewModel))
    }
}

struct ProfileViewModel {
    var firstName: String?
    var lastName: String?
    var emailAddress: String
}
