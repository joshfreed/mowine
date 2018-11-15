//
//  FirstTimeInteractorTests.swift
//  mowine
//
//  Created by Josh Freed on 3/29/18.
//  Copyright (c) 2018 Josh Freed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import mowine
import XCTest
import Nimble

class FirstTimeInteractorTests: XCTestCase {
    // MARK: Subject under test

    var sut: FirstTimeInteractor!
    let presenter = FirstTimePresentationLogicSpy()
    var worker: FirstTimeWorker!
    let facebookAuth = MockFacebookAuthService()
    let facebookGraphApi = MockFacebookGraphApi()
    let userRepository = TestUserRepository()
    let session = MockSession()

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        worker = FirstTimeWorker(
            fbAuth: facebookAuth,
            fbGraphApi: facebookGraphApi,
            userRepository: userRepository,
            session: session
        )
        setupFirstTimeInteractor()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: Test setup

    func setupFirstTimeInteractor() {
        sut = FirstTimeInteractor()
        sut.presenter = presenter
        sut.worker = worker
    }

    // MARK: Test doubles

    class FirstTimePresentationLogicSpy: FirstTimePresentationLogic {
        var presentFacebookLoginCalled = false

        func presentFacebookLogin(response: FirstTime.FacebookLogin.Response) {
            presentFacebookLoginCalled = true
        }
        func verifyPresentedFacebookLoginSuccess() {
            expect(self.presentFacebookLoginCalled).to(beTrue())
        }
    }

    // MARK: Tests

    // Login succeeds. User not in repository. Add to repo; present success.
    // Login succeeds. User not in repository. Add to repo fails. Present error.
    // Login fails. No intertaction with repository. Present failure.
    
    func testLoginWithFacebook() {
        // Given
        let token = "abcdefghijklmnop"
        facebookAuth.signInWillSucceed()
        facebookGraphApi.setMe(emailAddress: "jbomb@gmail.com", firstName: "Jimbo", lastName: "Jones")
        session.login(userId: UserId())
        userRepository.doesNotContainUser(emailAddress: "jbomb@gmail.com")
        userRepository.saveUserWillSucceed()
        
        // When
        sut.linkToFacebookLogin(fbToken: token)

        // Then
        userRepository.verifyUserAddedToRepository(emailAddress: "jbomb@gmail.com", firstName: "Jimbo", lastName: "Jones")
        presenter.verifyPresentedFacebookLoginSuccess()
    }
}
