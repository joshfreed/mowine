//
//  EditProfileService.swift
//  mowine
//
//  Created by Josh Freed on 6/16/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import Foundation
import UIKit.UIImage

public class EditProfileService {
    let session: Session
    let profilePictureWorker: ProfilePictureWorkerProtocol
    let userProfileService: UserProfileService
    let userRepository: UserRepository

    private(set) var newProfilePicture: UIImage?

    public init(session: Session, profilePictureWorker: ProfilePictureWorkerProtocol, userProfileService: UserProfileService, userRepository: UserRepository) {
        self.session = session
        self.profilePictureWorker = profilePictureWorker
        self.userProfileService = userProfileService
        self.userRepository = userRepository
    }
    
    public func updateProfilePicture(_ image: UIImage) {
        newProfilePicture = image
    }

    public func saveProfile(email: String, fullName: String) async throws {
        if let newProfilePicture = newProfilePicture {
            try await userProfileService.updateProfilePicture(newProfilePicture)
            self.newProfilePicture = nil
        }
        try await userProfileService.updateEmailAddress(emailAddress: email)
        try await userProfileService.updateUserProfile(.init(fullName: fullName))
    }
}
