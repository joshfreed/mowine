//
//  Mocks.swift
//  mowineTests
//
//  Created by Josh Freed on 2/21/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
@testable import mowine
import JFLib
import PromiseKit

class MockWineRepository: WineRepository {
    func getWineTypeNamesWithAtLeastOneWineLogged(userId: UserId, completion: @escaping (JFLib.Result<[String]>) -> ()) {
        
    }
    
    func getWine(by id: WineId, completion: @escaping (JFLib.Result<Wine>) -> ()) {
        
    }
    
    func add(_ wine: Wine, completion: @escaping (JFLib.Result<Wine>) -> ()) {
        
    }
    
    func getWines(userId: UserId, completion: @escaping (JFLib.Result<[Wine]>) -> ()) {
        
    }
    
    func save(_ wine: Wine, completion: @escaping (JFLib.Result<Wine>) -> ()) {
        completion(.success(wine))
    }
    
    func delete(_ wine: Wine, completion: @escaping (EmptyResult) -> ()) {
        completion(.success)
    }
    
    func getTopWines(userId: UserId, completion: @escaping (JFLib.Result<[Wine]>) -> ()) {
        
    }
    
    func getWines(userId: UserId, wineType: WineType, completion: @escaping (JFLib.Result<[Wine]>) -> ()) {
        
    }
}

class MockWineTypeRepository: WineTypeRepository {
    var types: [WineType] = []
    
    func getAll(completion: @escaping (JFLib.Result<[WineType]>) -> ()) {
        completion(.success(types))
    }
    
    func getWineType(named name: String, completion: @escaping (JFLib.Result<WineType?>) -> ()) {
        let type = types.first(where: { $0.name == name })
        completion(.success(type))        
    }
}

class MockUserRepository: UserRepository {
    func getUserByIdAndListenForUpdates(id: UserId, completion: @escaping (JFLib.Result<User?>) -> ()) -> MoWineListenerRegistration {
        return FakeRegistration()
    }
    
    func add(user: User, completion: @escaping (JFLib.Result<User>) -> ()) {
        
    }
    
    func isFriendOf(userId: UserId, otherUserId: UserId, completion: @escaping (JFLib.Result<Bool>) -> ()) {
        
    }
    
    func save(user: User, completion: @escaping (JFLib.Result<User>) -> ()) {
        
    }
    
    var getFriendsOfResult: JFLib.Result<[User]>?
    var getFriendsOf_userId: UserId?
    var getFriendsOfWasCalled = false
    func getFriendsOf(userId: UserId, completion: @escaping (JFLib.Result<[User]>) -> ()) {
        getFriendsOfWasCalled = true
        getFriendsOf_userId = userId
        if let result = getFriendsOfResult {
            completion(result)
        }
    }
    
    var searchUsersResult: JFLib.Result<[User]>?
    var searchUsers_searchString: String?
    var searchUsersWasCalled = false
    func searchUsers(searchString: String, completion: @escaping (JFLib.Result<[User]>) -> ()) {
        searchUsersWasCalled = true
        searchUsers_searchString = searchString
        if let result = searchUsersResult {
            completion(result)
        }
    }
    
    var addFriendCalled = false
    var addFriend_owningUserId: UserId?
    var addFriend_friendId: UserId?
    var addFriendResult: JFLib.Result<User>?
    func addFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (JFLib.Result<User>) -> ()) {
        addFriendCalled = true
        addFriend_owningUserId = owningUserId
        addFriend_friendId = friendId
        if let result = addFriendResult {
            completion(result)
        }
    }

    func removeFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (EmptyResult) -> ()) {

    }

    var getUserByIdResult: JFLib.Result<User?>?
    var getUserByIdCalled = false
    var getUserById_id: UserId?
    func getUserById(_ id: UserId, completion: @escaping (JFLib.Result<User?>) -> ()) {
        getUserByIdCalled = true
        getUserById_id = id
        if let result = getUserByIdResult {
            completion(result)
        }
    }
}

class MockSession: Session {
    private var _currentUser: User?
    var photoUrl: URL?
    
    var isLoggedIn: Bool {
        return _currentUser != nil
    }
    
    var _currentUserId: UserId?
    var currentUserId: UserId? {
        return _currentUserId ?? _currentUser?.id
    }
    
    func resume(completion: @escaping (EmptyResult) -> ()) {
        
    }
    
    func login(userId: UserId) {
        _currentUserId = userId
    }
    
    func login(user: User) {
        _currentUser = user
    }

    func getCurrentAuth() -> MoWineAuth? {
        if let currentUser = _currentUser {
            return MockAuth(email: currentUser.emailAddress)
        } else {
            return nil
        }
    }
    
    func getCurrentUser(completion: @escaping (JFLib.Result<User>) -> ()) {
        if let currentUser = _currentUser {
            completion(.success(currentUser))
        } else {
            // ??DF?DF?
        }
    }
    
    func getCurrentUser() -> Promise<User> {
        if let currentUser = _currentUser {
            return Promise { $0.fulfill(currentUser) }
        } else {
            return Promise { $0.reject(SessionError.notLoggedIn) }
        }
    }
    
    func end() {
        _currentUser = nil
    }
    
    func setPhotoUrl(_ url: URL, completion: @escaping (EmptyResult) -> ()) {
        photoUrl = url
        completion(.success)
    }
    
    func getPhotoUrl() -> URL? {
        return photoUrl
    }
    
    func updateEmailAddress(_ emailAddress: String) -> Promise<Void> {
        return Promise()
    }

    func reauthenticate(withEmail email: String, password: String, completion: @escaping (Swift.Result<Void, Error>) -> ()) {

    }
}

struct MockAuth: MoWineAuth {
    var email: String?
}

class MockEmailAuthService: EmailAuthenticationService {
    var signInCalled = false
    var signIn_emailAddress: String?
    var signIn_password: String?
    var signInResult: EmptyResult?
    func signIn(emailAddress: String, password: String, completion: @escaping (EmptyResult) -> ()) {
        signInCalled = true
        signIn_emailAddress = emailAddress
        signIn_password = password
        if let result = signInResult {
            completion(result)
        }
    }
    
    var signUpCalled = false
    var signUp_emailAddress: String?
    var signUp_password: String?
    var signUpResult: EmptyResult?
    func signUp(emailAddress: String, password: String, completion: @escaping (EmptyResult) -> ()) {
        signUpCalled = true
        signUp_emailAddress = emailAddress
        signUp_password = password
        if let result = signUpResult {
            completion(result)
        }
    }
}

class MockProfilePictureWorker: ProfilePictureWorkerProtocol {
    func setProfilePicture(image: UIImage, completion: @escaping (EmptyResult) -> ()) {
        
    }
    
    func getProfilePicture(user: User, completion: @escaping (JFLib.Result<Data?>) -> ()) {
        
    }
    
    func getProfilePicture(url: URL, completion: @escaping (JFLib.Result<Data?>) -> ()) {
        
    }
}

class MockUserProfileService: UserProfileService {
    init() {
        super.init(session: MockSession(), userRepository: MockUserRepository(), profilePictureWorker: MockProfilePictureWorker())
    }

    var updateProfilePictureWasCalled = false
    var updateProfilePicture_image: UIImage?
    var updateProfilePicture_rejection: Error?
    override func updateProfilePicture(_ image: UIImage?) -> Promise<Void> {
        updateProfilePictureWasCalled = true
        updateProfilePicture_image = image

        if let error = updateProfilePicture_rejection {
            return Promise { $0.reject(error) }
        } else {
            return Promise()
        }
    }

    var updateEmailAddressWasCalled = false
    var updateEmailAddress_emailAddress: String?
    override func updateEmailAddress(emailAddress: String) -> Promise<Void> {
        updateEmailAddressWasCalled = true
        updateEmailAddress_emailAddress = emailAddress
        return Promise { $0.fulfill_() }
    }

    var updateUserProfileWasCalled = false
    var updateUserProfile_request: UpdateUserProfileRequest?
    override func updateUserProfile(_ request: UpdateUserProfileRequest) -> Promise<Void> {
        updateUserProfileWasCalled = true
        updateUserProfile_request = request
        return Promise { $0.fulfill_() }
    }
}
