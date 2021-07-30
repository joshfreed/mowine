//
//  Mocks.swift
//  mowineTests
//
//  Created by Josh Freed on 2/21/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import UIKit
@testable import mowine
import Combine
import Model

class MockWineRepository: WineRepository {
    func getWineTypeNamesWithAtLeastOneWineLogged(userId: UserId, completion: @escaping (Swift.Result<[String], Error>) -> ()) {
        
    }
    
    func getWine(by id: WineId, completion: @escaping (Swift.Result<Wine, Error>) -> ()) {
        
    }
    
    func add(_ wine: Wine) async throws {}
    
    func getWines(userId: UserId, completion: @escaping (Swift.Result<[Wine], Error>) -> ()) -> MoWineListenerRegistration {
        return FakeRegistration()
    }
    
    func save(_ wine: Wine, completion: @escaping (Swift.Result<Wine, Error>) -> ()) {
        completion(.success(wine))
    }
    
    func delete(_ wine: Wine, completion: @escaping (Swift.Result<Void, Error>) -> ()) {
        completion(.success(()))
    }
    
    func getTopWines(userId: UserId, completion: @escaping (Swift.Result<[Wine], Error>) -> ()) {
        
    }
    
    func getWines(userId: UserId, wineType: WineType, completion: @escaping (Swift.Result<[Wine], Error>) -> ()) -> MoWineListenerRegistration {
        return FakeRegistration()
    }
}

class MockWineTypeRepository: WineTypeRepository {
    var types: [WineType] = []
    
    func getAll(completion: @escaping (Swift.Result<[WineType], Error>) -> ()) {
        completion(.success(types))
    }
    
    func getWineType(named name: String, completion: @escaping (Swift.Result<WineType?, Error>) -> ()) {
        let type = types.first(where: { $0.name == name })
        completion(.success(type))        
    }
}

class MockUserRepository: UserRepository {
    func getFriendsOfAndListenForUpdates(userId: UserId, completion: @escaping (Swift.Result<[User], Error>) -> ()) -> MoWineListenerRegistration {
        return FakeRegistration()
    }

    func getUserByIdAndListenForUpdates(id: UserId, completion: @escaping (Swift.Result<User?, Error>) -> ()) -> MoWineListenerRegistration {
        return FakeRegistration()
    }
    
    func add(user: User, completion: @escaping (Swift.Result<User, Error>) -> ()) {
        
    }
    
    func isFriendOf(userId: UserId, otherUserId: UserId, completion: @escaping (Swift.Result<Bool, Error>) -> ()) {
        
    }
    
    func save(user: User, completion: @escaping (Swift.Result<User, Error>) -> ()) {
        
    }
    
    var getFriendsOfResult: Swift.Result<[User], Error>?
    var getFriendsOf_userId: UserId?
    var getFriendsOfWasCalled = false
    func getFriendsOf(userId: UserId, completion: @escaping (Swift.Result<[User], Error>) -> ()) {
        getFriendsOfWasCalled = true
        getFriendsOf_userId = userId
        if let result = getFriendsOfResult {
            completion(result)
        }
    }
    
    var searchUsersResult: Swift.Result<[User], Error>?
    var searchUsers_searchString: String?
    var searchUsersWasCalled = false
    func searchUsers(searchString: String, completion: @escaping (Swift.Result<[User], Error>) -> ()) {
        searchUsersWasCalled = true
        searchUsers_searchString = searchString
        if let result = searchUsersResult {
            completion(result)
        }
    }
    
    var addFriendCalled = false
    var addFriend_owningUserId: UserId?
    var addFriend_friendId: UserId?
    var addFriendResult: Swift.Result<User, Error>?
    func addFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (Swift.Result<User, Error>) -> ()) {
        addFriendCalled = true
        addFriend_owningUserId = owningUserId
        addFriend_friendId = friendId
        if let result = addFriendResult {
            completion(result)
        }
    }

    func removeFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (Swift.Result<Void, Error>) -> ()) {

    }

    var getUserByIdResult: Swift.Result<User?, Error>?
    var getUserByIdCalled = false
    var getUserById_id: UserId?
    func getUserById(_ id: UserId, completion: @escaping (Swift.Result<User?, Error>) -> ()) {
        getUserByIdCalled = true
        getUserById_id = id
        if let result = getUserByIdResult {
            completion(result)
        }
    }
}

class MockSession: Session {
    var isAnonymous: Bool = false
    
    var _currentUserIdPub = CurrentValueSubject<UserId?, Never>(nil)
    
    var currentUserIdPublisher: AnyPublisher<UserId?, Never> {
        _currentUserIdPub.eraseToAnyPublisher()
    }
    
    var _authStateDidChange = PassthroughSubject<AuthState, Never>()
    
    var authStateDidChange: AnyPublisher<AuthState, Never> {
        _authStateDidChange.eraseToAnyPublisher()
    }
    
    private var _currentUser: User?
    var photoUrl: URL?
    
    var isLoggedIn: Bool {
        return _currentUser != nil
    }
    
    var _currentUserId: UserId?
    var currentUserId: UserId? {
        return _currentUserId ?? _currentUser?.id
    }
    
    func start() {}

    func startAnonymous() async throws {}
    
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
    
    func getCurrentUser(completion: @escaping (Swift.Result<User, Error>) -> ()) {
        if let currentUser = _currentUser {
            completion(.success(currentUser))
        } else {
            // ??DF?DF?
        }
    }

    func end() {
        _currentUser = nil
    }
    
    func setPhotoUrl(_ url: URL, completion: @escaping (Swift.Result<Void, Error>) -> ()) {
        photoUrl = url
        completion(.success(()))
    }
    
    func getPhotoUrl() -> URL? {
        return photoUrl
    }
    
    func updateEmailAddress(_ emailAddress: String) -> Future<Void, Error> {
        return Future { promise in promise(.success(())) }
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
    var signInResult: Swift.Result<Void, Error>?
    func signIn(emailAddress: String, password: String, completion: @escaping (Swift.Result<Void, Error>) -> ()) {
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
    var signUpResult: Swift.Result<Void, Error>?
    func signUp(emailAddress: String, password: String, completion: @escaping (Swift.Result<Void, Error>) -> ()) {
        signUpCalled = true
        signUp_emailAddress = emailAddress
        signUp_password = password
        if let result = signUpResult {
            completion(result)
        }
    }
}

class MockProfilePictureWorker: ProfilePictureWorkerProtocol {
    func setProfilePicture(image: UIImage, completion: @escaping (Swift.Result<Void, Error>) -> ()) {
        
    }
    
    func getProfilePicture(user: User, completion: @escaping (Swift.Result<Data?, Error>) -> ()) {
        
    }
    
    func getProfilePicture(url: URL, completion: @escaping (Swift.Result<Data?, Error>) -> ()) {
        
    }
}

class MockUserProfileService: UserProfileService {
    init() {
        super.init(session: MockSession(), userRepository: MockUserRepository(), profilePictureWorker: MockProfilePictureWorker())
    }

    var updateProfilePictureWasCalled = false
    var updateProfilePicture_image: UIImage?
    var updateProfilePicture_rejection: Error?
    override func updateProfilePicture(_ image: UIImage?) -> AnyPublisher<Void, Error> {
        updateProfilePictureWasCalled = true
        updateProfilePicture_image = image

        if let error = updateProfilePicture_rejection {
            return Fail(error: error).eraseToAnyPublisher()
        } else {
            return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }

    var updateEmailAddressWasCalled = false
    var updateEmailAddress_emailAddress: String?
    override func updateEmailAddress(emailAddress: String) -> AnyPublisher<Void, Error> {
        updateEmailAddressWasCalled = true
        updateEmailAddress_emailAddress = emailAddress
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    var updateUserProfileWasCalled = false
    var updateUserProfile_request: UpdateUserProfileRequest?
    override func updateUserProfile(_ request: UpdateUserProfileRequest) -> AnyPublisher<Void, Error> {
        updateUserProfileWasCalled = true
        updateUserProfile_request = request
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
