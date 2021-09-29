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
import XCTest

class MockUserRepository: UserRepository {
    func getFriendsOfAndListenForUpdates(userId: UserId, completion: @escaping (Swift.Result<[User], Error>) -> ()) -> MoWineListenerRegistration {
        return FakeRegistration()
    }

    func getUserByIdAndListenForUpdates(id: UserId, completion: @escaping (Swift.Result<User?, Error>) -> ()) -> MoWineListenerRegistration {
        return FakeRegistration()
    }
    
    func add(user: User) async throws {
    }

    func save(user: User) async throws {}

    var searchUsersResult: Result<[User], Error> = .success([])
    var searchUsers_searchString: String?
    var searchUsersWasCalled = false
    func searchUsers(searchString: String) async throws -> [User] {
        searchUsersWasCalled = true
        searchUsers_searchString = searchString
        switch searchUsersResult {
        case .success(let users): return users
        case.failure(let error): throw error
        }
    }
    
    var addFriendCalled = false
    var addFriend_owningUserId: UserId?
    var addFriend_friendId: UserId?
    var addFriendResult: Swift.Result<User, Error>?
    func addFriend(owningUserId: UserId, friendId: UserId) async throws -> User {
        addFriendCalled = true
        addFriend_owningUserId = owningUserId
        addFriend_friendId = friendId
        guard let result = addFriendResult else { fatalError() }
        switch result {
        case .success(let user): return user
        case .failure(let error): throw error
        }
    }

    func removeFriend(owningUserId: UserId, friendId: UserId) async throws {

    }

    var getUserByIdResult: Swift.Result<User?, Error>?
    var getUserByIdCalled = false
    var getUserById_id: UserId?
    func getUserById(_ id: UserId) async throws -> User? {
        getUserByIdCalled = true
        getUserById_id = id
        if let result = getUserByIdResult, case let .success(user) = result {
            return user
        }
        if let result = getUserByIdResult, case let .failure(error) = result {
            throw error
        }
        fatalError("Test not configured")
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
    
    func updateEmailAddress(_ emailAddress: String) async throws {}

    func reauthenticate(withEmail email: String, password: String) async throws {}
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

    func signIn(emailAddress: String, password: String) async throws {
        return try await withCheckedThrowingContinuation { cont in
            signIn(emailAddress: emailAddress, password: password)  { res in
                cont.resume(with: res)
            }
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

    func signUp(emailAddress: String, password: String) async throws {
        return try await withCheckedThrowingContinuation { cont in
            signUp(emailAddress: emailAddress, password: password)  { res in
                cont.resume(with: res)
            }
        }
    }

    func forgotPassword(emailAddress: String) async throws {}
}

class MockProfilePictureWorker: ProfilePictureWorkerProtocol {
    func setProfilePicture(image: UIImage) async throws {
    }

    func getProfilePicture(url: URL) async throws -> Data? {
        nil
    }

    func getProfilePicture(user: User, completion: @escaping (Swift.Result<Data?, Error>) -> ()) {
        
    }
}

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
