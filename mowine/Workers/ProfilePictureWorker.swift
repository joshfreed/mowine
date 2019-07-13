//
// Created by Josh Freed on 2019-01-14.
// Copyright (c) 2019 Josh Freed. All rights reserved.
//

import UIKit
import SwiftyBeaver
import JFLib

protocol ProfilePictureWorkerProtocol {
    func setProfilePicture(image: UIImage, completion: @escaping (EmptyResult) -> ())
    func getProfilePicture(user: User, completion: @escaping (Result<Data?>) -> ())
    func getProfilePicture(url: URL, completion: @escaping (Result<Data?>) -> ())
}

class ProfilePictureWorker<DataServiceType: DataServiceProtocol>: ProfilePictureWorkerProtocol
where
    DataServiceType.GetDataUrl == URL,
    DataServiceType.PutDataUrl == String
{
    let session: Session
    let profilePictureService: DataServiceType
    let userRepository: UserRepository

    init(session: Session, profilePictureService: DataServiceType, userRepository: UserRepository) {
        self.session = session
        self.profilePictureService = profilePictureService
        self.userRepository = userRepository
    }

    func setProfilePicture(image: UIImage, completion: @escaping (EmptyResult) -> ()) {
        guard
            let downsizedImage = image.resize(to: CGSize(width: 400, height: 400)),
            let imageData = downsizedImage.pngData()
        else {
            return
        }
        
        guard let userId = session.currentUserId else {
            completion(.failure(SessionError.notLoggedIn))
            return
        }

        userRepository.getUserById(userId) { result in
            switch result {
            case .success(let user):
                if let user = user {
                    self.uploadImage(imageData, user: user, completion: completion)
                } else {
                    completion(.failure(UserRepositoryError.userNotFound))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func uploadImage(_ imageData: Data, user: User, completion: @escaping (EmptyResult) -> ()) {
        profilePictureService.putData(imageData, url: "\(user.id)/profile.png") { result in
            switch result {
            case .success(let url): self.setUserProfilePictureUrl(user: user, url: url, completion: completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }

    private func setUserProfilePictureUrl(user: User, url: URL, completion: @escaping (EmptyResult) -> ()) {
        var _user = user
        _user.profilePictureUrl = url
        userRepository.save(user: _user) { result in
            switch result {
            case .success: completion(.success)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
    
    func getProfilePicture(user: User, completion: @escaping (Result<Data?>) -> ()) {
        guard let url = user.profilePictureUrl else {
            completion(.success(nil))
            return
        }
        profilePictureService.getData(url: url, completion: completion)
    }
    
    func getProfilePicture(url: URL, completion: @escaping (Result<Data?>) -> ()) {
        profilePictureService.getData(url: url, completion: completion)
    }
}
