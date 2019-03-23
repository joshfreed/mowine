//
//  SocialSignInWorkerTests.swift
//  mowineTests
//
//  Created by Josh Freed on 3/23/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import XCTest
@testable import mowine
import Nimble
import JFLib

class SocialSignInWorkerTests: XCTestCase {
    var sut: SocialSignInWorker<FakeSocialProvider>!
    let provider = FakeSocialProvider()
    let userRepository = FakeUserRepository()
    let session = FakeSession()
    
    class FakeSocialToken: SocialToken {
        
    }
    
    class FakeSocialProvider: SocialSignInProvider {
        func linkAccount(token: FakeSocialToken, completion: @escaping (EmptyResult) -> ()) {
            
        }
        func getNewUserInfo(completion: @escaping (Result<NewUserInfo>) -> ()) {
            
        }
        func getProfilePictureUrl(_ urlString: String) -> String {
            return urlString
        }
    }
    
    override func setUp() {
        sut = SocialSignInWorker<FakeSocialProvider>(userRepository: userRepository, session: session, provider: provider)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}
