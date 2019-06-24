//
//  MoreDoubles.swift
//  mowineTests
//
//  Created by Josh Freed on 3/29/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
@testable import mowine
import JFLib
import Nimble

class TestEmailAuthService: EmailAuthenticationService {
    var identities: [String: String] = [:]
    
    func identityDoesNotExist(for emailAddress: String) {
        identities.removeValue(forKey: emailAddress)
    }
    
    func identity(for emailAddress: String, password: String) {
        identities[emailAddress] = password
    }
    
    var signInResult: EmptyResult?
    func signIn(emailAddress: String, password: String, completion: @escaping (EmptyResult) -> ()) {
        if let result = signInResult {
            completion(result)
            return
        }
        
        guard let identity = identities[emailAddress] else {
            completion(.failure(EmailAuthenticationErrors.userNotFound))
            return
        }
        
        guard identity == password else {
            completion(.failure(EmailAuthenticationErrors.notAuthorized))
            return
        }
        
        completion(.success)
    }
    func signInWillFail(error: Error) {
        signInResult = .failure(error)
    }
    
    var signUpResult: EmptyResult?
    var signedUp: String?
    func signUp(emailAddress: String, password: String, completion: @escaping (EmptyResult) -> ()) {
        signedUp = emailAddress
        identities[emailAddress] = password
        if let result = signUpResult {
            completion(result)
        }
    }
    
    func signUpWillSucceed() {
        signUpResult = .success
    }
    func signUpWillFail(error: Error) {
        signUpResult = .failure(error)
    }
    
    func verifyIdentityCreated(emailAddress: String, password: String) {
        if let pw = identities[emailAddress], pw == password {
            
        } else {
            fail("User was not signed up")
        }
    }
    
    func verifyIdentityWasNotCreated() {
        expect(self.signedUp).to(beNil())
    }
}

enum TestError: Error {
    case unknownError
}

class TestUserRepository: UserRepository {
    func getUserByIdAndListenForUpdates(id: UserId, completion: @escaping (Result<User?>) -> ()) -> MoWineListenerRegistration {
        return FakeRegistration()
    }
    
    func doesNotContainUser(emailAddress: String) {
        
    }
    var _user: User?
    func containsUser(emailAddress: String) {
        _user = UserBuilder.aUser().withEmail(emailAddress).build()
    }
    
    var addUserCalled = false
    var addedUser: User?
    var addUserResult: Result<User>?
    func add(user: User, completion: @escaping (Result<User>) -> ()) {
        addUserCalled = true
        addedUser = user
        if let result = addUserResult {
            completion(result)
        }
    }
    func addUserWillSucceed() {
        let userToReturn = User(emailAddress: "smelly@mybutt.com")
        addUserResult = .success(userToReturn)
    }
    func addUserWillFail(error: Error) {
        addUserResult = .failure(error)
    }
    func verifyUserAddedToRepository(emailAddress: String, firstName: String, lastName: String) {
        expect(self.addUserCalled).to(beTrue())
        expect(self.addedUser).toNot(beNil())
        expect(self.addedUser?.emailAddress).to(equal(emailAddress))
        expect(self.addedUser?.firstName).to(equal(firstName))
        expect(self.addedUser?.lastName).to(equal(lastName))
    }
    func verifyUserNotAddedToRepository() {
        expect(self.addUserCalled).to(beFalse())
        expect(self.addedUser).to(beNil())
    }
    
    var saveUserCalled = false
    var savedUser: User?
    var saveUserResult: Result<User>?
    func save(user: User, completion: @escaping (Result<User>) -> ()) {
        saveUserCalled = true
        savedUser = user
        if let result = saveUserResult {
            completion(result)
        }
    }
    func saveUserWillSucceed() {
        let userToReturn = User(emailAddress: "smelly@mybutt.com")
        saveUserResult = .success(userToReturn)
    }
    func saveUserWillFail(error: Error) {
        saveUserResult = .failure(error)
    }
    func verifyUserSavedToRepository(emailAddress: String, firstName: String, lastName: String) {
        expect(self.saveUserCalled).to(beTrue())
        expect(self.savedUser).toNot(beNil())
        expect(self.savedUser?.emailAddress).to(equal(emailAddress))
        expect(self.savedUser?.firstName).to(equal(firstName))
        expect(self.savedUser?.lastName).to(equal(lastName))
    }
    func verifyUserNotSavedToRepository() {
        expect(self.saveUserCalled).to(beFalse())
        expect(self.savedUser).to(beNil())
    }
    
    func getFriendsOf(userId: UserId, completion: @escaping (Result<[User]>) -> ()) {
        
    }
    
    func searchUsers(searchString: String, completion: @escaping (Result<[User]>) -> ()) {
        
    }
    
    func addFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (Result<User>) -> ()) {
        
    }
    
    func removeFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (EmptyResult) -> ()) {
        
    }
    
    func getUserById(_ id: UserId, completion: @escaping (Result<User?>) -> ()) {
        completion(.success(_user))
    }
    
    func isFriendOf(userId: UserId, otherUserId: UserId, completion: @escaping (Result<Bool>) -> ()) {
        
    }
}
