//
//  SignUpInteractorTests.swift
//  mowine
//
//  Created by Josh Freed on 3/28/18.
//  Copyright (c) 2018 Josh Freed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import mowine
import XCTest
import JFLib
import Nimble

class SignUpInteractorTests: XCTestCase {
    // MARK: Subject under test

    var sut: SignUpInteractor!
    let presenter = SignUpPresentationLogicSpy()
    let emailAuthService = TestEmailAuthService()
    let userRepository = TestUserRepository()
    let session = MockSession()

    // MARK: Test lifecycle

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        setupSignUpInteractor()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: Test setup

    func setupSignUpInteractor() {
        sut = SignUpInteractor()
        sut.presenter = presenter
        sut.worker = SignUpWorker(emailAuthService: emailAuthService, userRepository: userRepository, session: session)
    }

    // MARK: Test doubles

    class SignUpPresentationLogicSpy: SignUpPresentationLogic {
        var presentSignUpCalled = false
        var presentSignUpResponse: SignUp.SignUp.Response?
        func presentSignUp(response: SignUp.SignUp.Response) {
            presentSignUpCalled = true
            presentSignUpResponse = response
        }
        func verifyPresentedSignUpSuccess(emailAddress: String) {
            expect(self.presentSignUpCalled).to(beTrue())
            expect(self.presentSignUpResponse).toNot(beNil())
            expect(self.presentSignUpResponse?.user).toNot(beNil())
            expect(self.presentSignUpResponse?.user?.emailAddress).to(equal(emailAddress))
            expect(self.presentSignUpResponse?.error).to(beNil())
            expect(self.presentSignUpResponse?.message).to(beNil())
        }
        func verifyPresentedSignUpFailure(error: Error) {
            expect(self.presentSignUpCalled).to(beTrue())
            expect(self.presentSignUpResponse).toNot(beNil())
            expect(self.presentSignUpResponse?.user).to(beNil())
            expect(self.presentSignUpResponse?.error).toNot(beNil())
            expect(self.presentSignUpResponse?.message).to(beNil())

            var expectedError: String?
            if let err = presentSignUpResponse?.error {
                expectedError = "\(err)"
            }
            expect(expectedError).to(equal("\(error)"))
        }
        func verifyPresentedSignUpFailure(error: Error, message: String) {
            expect(self.presentSignUpCalled).to(beTrue())
            expect(self.presentSignUpResponse).toNot(beNil())
            expect(self.presentSignUpResponse?.user).to(beNil())
            expect(self.presentSignUpResponse?.error).toNot(beNil())
            expect(self.presentSignUpResponse?.message).toNot(beNil())
            expect(self.presentSignUpResponse?.message).to(equal(message))
            
            var expectedError: String?
            if let err = presentSignUpResponse?.error {
                expectedError = "\(err)"
            }
            expect(expectedError).to(equal("\(error)"))
        }
    }

    // MARK: Tests
    
    // Happy path. The user's identity is created and a user object is added to the repository
    func test_signUp() {
        // Given
        emailAuthService.signUpWillSucceed()
        session.login(userId: UserId())
        userRepository.saveUserWillSucceed()
        let request = SignUp.SignUp.Request(firstName: "Jeff", lastName: "Beans", emailAddress: "jbone@test.com", password: "password123")

        // When
        sut.signUp(request: request)

        // Then
        emailAuthService.verifyIdentityCreated(emailAddress: "jbone@test.com", password: "password123")
        userRepository.verifyUserAddedToRepository(emailAddress: "jbone@test.com", firstName: "Jeff", lastName: "Beans")
        presenter.verifyPresentedSignUpSuccess(emailAddress: "jbone@test.com")
    }
    
    func test_signUp_anErrorOccursWhileCreatingTheIdentity() {
        // Given
        emailAuthService.signUpWillFail(error: TestError.unknownError)
        let request = SignUp.SignUp.Request(firstName: "Jeff", lastName: "Beans", emailAddress: "jbone@test.com", password: "password123")
        
        // When
        sut.signUp(request: request)
        
        // Then
        userRepository.verifyUserNotAddedToRepository()
        presenter.verifyPresentedSignUpFailure(error: TestError.unknownError)
    }
    
    func test_signUp_anErrorOccursWhileAddingTheUserToTheRepository() {
        // Given
        session.login(userId: UserId()) // added this to make it pass - does it make sense for the use case tho?
        emailAuthService.signUpWillSucceed()
        userRepository.saveUserWillFail(error: TestError.unknownError)
        let request = SignUp.SignUp.Request(firstName: "Jeff", lastName: "Beans", emailAddress: "jbone@test.com", password: "password123")
        
        // When
        sut.signUp(request: request)
        
        // Then
        emailAuthService.verifyIdentityCreated(emailAddress: "jbone@test.com", password: "password123")
        presenter.verifyPresentedSignUpFailure(error: TestError.unknownError)
    }
    
    func test_signUp_theEmailAuthServiceRejectsThePassword() {
        // Given
        let error = EmailAuthenticationErrors.invalidPassword(message: "Your password is invalid")
        emailAuthService.identityDoesNotExist(for: "jbone@test.com")
        emailAuthService.signUpWillFail(error: error)
        let request = SignUp.SignUp.Request(firstName: "Jeff", lastName: "Beans", emailAddress: "jbone@test.com", password: "password123")
        
        // When
        sut.signUp(request: request)
        
        // Then
        userRepository.verifyUserNotAddedToRepository()
        presenter.verifyPresentedSignUpFailure(error: error, message: "Your password is invalid")
    }
}
