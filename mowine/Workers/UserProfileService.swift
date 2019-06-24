//
//  UserProfileService.swift
//  mowine
//
//  Created by Josh Freed on 6/22/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import Foundation
import JFLib

class UserProfileService {
    let session: Session
    let userRepository: UserRepository
    
    init(session: Session, userRepository: UserRepository) {
        self.session = session
        self.userRepository = userRepository
    }
    
    func updateEmailAddress(emailAddress: String, completion: @escaping (EmptyResult) -> ()) {
        
    }
    
    func updateUserProfile(_ request: UpdateUserProfileRequest, completion: @escaping (EmptyResult) -> ()) {
        session.getCurrentUser { result in
            switch result {
            case .success(let user): self.updateUserProfileObject(user: user, request: request, completion: completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    private func updateUserProfileObject(user: User, request: UpdateUserProfileRequest, completion: @escaping (EmptyResult) -> ()) {
        var _user = user
        
        _user.firstName = request.firstName
        _user.lastName = request.lastName
        
        userRepository.save(user: _user) { result in
            switch result {
            case .success: completion(.success)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}

struct UpdateUserProfileRequest {
    let firstName: String?
    let lastName: String?
}
