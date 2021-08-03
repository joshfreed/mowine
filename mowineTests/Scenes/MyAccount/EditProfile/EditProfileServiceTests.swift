//
//  EditProfileServiceTests.swift
//  mowineTests
//
//  Created by Josh Freed on 6/24/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import XCTest
@testable import mowine
import Nimble

class EditProfileServiceTests: XCTestCase {
    var sut: EditProfileService!
    let session = MockSession()
    let profilePictureWorker = MockProfilePictureWorker()
    let userProfileService = MockUserProfileService()
    let userRepository = MockUserRepository()

    override func setUp() {
        sut = EditProfileService(
            session: session,
            profilePictureWorker: profilePictureWorker,
            userProfileService: userProfileService,
            userRepository: userRepository
        )
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //
    // updateProfilePicture
    //

    func test_updateProfilePicture() {
        let newPicture = UIImage(color: .black)!
        sut.updateProfilePicture(newPicture)
        expect(self.sut.newProfilePicture).to(be(newPicture))
    }

    //
    // Save profile
    //

    func test_saveProfile() async {
        let newPicture = UIImage(color: .black)!
        sut.updateProfilePicture(newPicture)

        do {
            try await sut.saveProfile(email: "test@test.com", fullName: "Jeff Jones")
        } catch {
            fail("Should not throw")
        }

        expect(self.userProfileService.updateProfilePictureWasCalled).to(beTrue())
        expect(self.userProfileService.updateProfilePicture_image).to(be(newPicture))
        expect(self.sut.newProfilePicture).to(beNil())
        expect(self.userProfileService.updateEmailAddressWasCalled).to(beTrue())
        expect(self.userProfileService.updateEmailAddress_emailAddress).to(equal("test@test.com"))
        expect(self.userProfileService.updateUserProfileWasCalled).to(beTrue())
        let request = self.userProfileService.updateUserProfile_request
        expect(request).toNot(beNil())
        expect(request?.fullName).to(equal("Jeff Jones"))
    }

    func test_saveProfile_updatingProfilePictureThrowsAnError() async {
        let newPicture = UIImage(color: .black)!
        sut.updateProfilePicture(newPicture)
        userProfileService.updateProfilePicture_rejection = TestError.someError

        do {
            try await sut.saveProfile(email: "test@test.com", fullName: "Jeff Jones")
            XCTFail("Should throw")
        } catch let error {
            expect(error).to(matchError(TestError.someError))
        }

        expect(self.userProfileService.updateProfilePictureWasCalled).to(beTrue())
        expect(self.userProfileService.updateProfilePicture_image).to(be(newPicture))
        expect(self.sut.newProfilePicture).toNot(beNil())
        expect(self.userProfileService.updateEmailAddressWasCalled).to(beFalse())
        expect(self.userProfileService.updateUserProfileWasCalled).to(beFalse())
    }
}
