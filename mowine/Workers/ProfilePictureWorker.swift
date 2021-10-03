//
// Created by Josh Freed on 2019-01-14.
// Copyright (c) 2019 Josh Freed. All rights reserved.
//

import UIKit
import SwiftyBeaver
import Model

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

    func setProfilePicture(image: UIImage) async throws {
        guard
            let downsizedImage = image.resize(to: CGSize(width: 400, height: 400)),
            let imageData = downsizedImage.pngData()
        else {
            return
        }

        guard let userId = session.currentUserId else {
            throw SessionError.notLoggedIn
        }

        guard let user = try await userRepository.getUserById(userId) else {
            throw UserRepositoryError.userNotFound
        }

        let url = try await profilePictureService.putData(imageData, url: "\(user.id)/profile.png")

        var _user = user
        _user.profilePictureUrl = url
        try await userRepository.save(user: _user)
    }
}
