//
//  MockUserProfileService.swift
//  
//
//  Created by Josh Freed on 9/30/21.
//

import Foundation
@testable import Model
import UIKit.UIImage

class MockUserProfileService: UserProfileService {
    init() {
        super.init(session: MockSession(), userRepository: MockUserRepository(), profilePictureWorker: MockProfilePictureWorker())
    }

    var updateProfilePictureWasCalled = false
    var updateProfilePicture_image: UIImage?
    var updateProfilePicture_rejection: Error?
    override func updateProfilePicture(_ image: UIImage) async throws {
        updateProfilePictureWasCalled = true
        updateProfilePicture_image = image

        if let error = updateProfilePicture_rejection {
            throw error
        }
    }

    var updateEmailAddressWasCalled = false
    var updateEmailAddress_emailAddress: String?
    override func updateEmailAddress(emailAddress: String) async throws {
        updateEmailAddressWasCalled = true
        updateEmailAddress_emailAddress = emailAddress
    }

    var updateUserProfileWasCalled = false
    var updateUserProfile_request: UpdateUserProfileRequest?
    override func updateUserProfile(_ request: UpdateUserProfileRequest) async throws {
        updateUserProfileWasCalled = true
        updateUserProfile_request = request
    }
}
