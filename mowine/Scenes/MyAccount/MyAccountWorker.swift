//
//  MyAccountWorker.swift
//  mowine
//
//  Created by Josh Freed on 2/27/18.
//  Copyright (c) 2018 Josh Freed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import JFLib
import SwiftyBeaver

enum MyAccountWorkerError: Error {
    case userNotFound
}

class MyAccountWorker {
    let session: Session
    let userRepository: UserRepository
    let imageService: ImageServiceProtocol
    
    init(session: Session, userRepository: UserRepository, imageService: ImageServiceProtocol) {
        self.session = session
        self.userRepository = userRepository
        self.imageService = imageService
    }
    
    func getCurrentUser(completion: @escaping (Result<User>) -> ()) {
        guard let currentUserId = session.currentUserId else {
            completion(.failure(MoWineError.notLoggedIn))
            return
        }
        
        userRepository.getUserById(currentUserId) { result in
            switch result {
            case .success(let user):
                if let user = user {
                    completion(.success(user))
                } else {
                    completion(.failure(MyAccountWorkerError.userNotFound))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getProfilePicture(completion: @escaping (Result<Data?>) -> ()) {
        guard let photoUrl = session.getPhotoUrl() else {
            SwiftyBeaver.verbose("No profile picture for current user")
            completion(.success(nil))
            return
        }

        SwiftyBeaver.verbose("Fetching profile picture: \(photoUrl)")

        do {
            let photoData = try Data(contentsOf: photoUrl)
            completion(.success(photoData))
        } catch {
            completion(.failure(error))
        }
    }
    
    func signOut() {
        session.end()
    }
}
