//
//  AppSyncUserRepository.swift
//  mowine
//
//  Created by Josh Freed on 11/17/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import AWSAppSync
import JFLib
import SwiftyBeaver

class AppSyncUserRepository: UserRepository {
    let appSyncClient: AWSAppSyncClient
    
    init(appSyncClient: AWSAppSyncClient) {
        self.appSyncClient = appSyncClient
    }
    
    private func hasError<T>(result: GraphQLResult<T>?, error: Error?) -> Error? {
        if let error = error {
            SwiftyBeaver.error("\(error)")
            SwiftyBeaver.error(error.localizedDescription)
            return error
        }
        
        if let errors = result?.errors, let firstError = errors.first {
            SwiftyBeaver.error("Result had \(errors.count) errors")
            SwiftyBeaver.error("\(errors)")
            return firstError
        }
        
        return nil
    }
    
    private func getUser(_ userId: UserId, completion: @escaping (JFLib.Result<User>) -> ()) {
        appSyncClient.fetch(query: GetUserQuery(id: userId.asString), cachePolicy: .returnCacheDataAndFetch) { (result, error) in
            if let error = self.hasError(result: result, error: error) {
                completion(.failure(error))
                return
            }
            
            guard let getUser = result?.data?.getUser else {
                completion(.failure(UserRepositoryError.userNotFound))
                return
            }
            
            let user = getUser.toUser()
            completion(.success(user))
        }
    }
    
    private func deleteFriendship(id: GraphQLID, completion: @escaping (EmptyResult) -> ()) {
        let input = DeleteFriendshipInput(id: id)
        appSyncClient.perform(mutation: DeleteFriendshipMutation(input: input)) { result, error in
            completion(.success)
        }
    }
    
    private func getUsers(by ids: [UserId], completion: @escaping (JFLib.Result<[User]>) -> ()) {
        var inputFilters: [ModelUserFilterInput] = []
        for userId in ids {
            inputFilters.append(ModelUserFilterInput(id: ModelIDFilterInput(eq: userId.asString)))
        }
        let filter = ModelUserFilterInput(or: inputFilters)
        appSyncClient.fetch(query: ListUsersQuery(filter: filter), cachePolicy: .returnCacheDataAndFetch) { result, error in
            if let error = self.hasError(result: result, error: error) {
                completion(.failure(error))
                return
            }
            
            guard let listUsers = result?.data?.listUsers?.items else {
                completion(.success([]))
                return
            }
            
            let users = listUsers.compactMap { $0?.toUser() }
            completion(.success(users))
        }
    }
    
    // MARK: - UserRepository
    
    func add(user: User, completion: @escaping (JFLib.Result<User>) -> ()) {
        let createUserInput = CreateUserInput(
            id: user.id.asString,
            email: user.emailAddress,
            firstName: user.firstName,
            lastName: user.lastName
        )
        
        appSyncClient.perform(mutation: CreateUserMutation(input: createUserInput)) { result, error in
            if let error = self.hasError(result: result, error: error) {
                completion(.failure(error))
                return
            }
            
            completion(.success(user))
        }
    }
    
    func save(user: User, completion: @escaping (JFLib.Result<User>) -> ()) {
        
    }
    
    func getFriendsOf(userId: UserId, completion: @escaping (JFLib.Result<[User]>) -> ()) {
        appSyncClient.fetch(query: GetUserQuery(id: userId.asString), cachePolicy: .returnCacheDataAndFetch) { (result, error) in
            if let error = self.hasError(result: result, error: error) {
                completion(.failure(error))
                return
            }
            
            guard let friendItems = result?.data?.getUser?.friends?.items else {
                completion(.success([]))
                return
            }
            
            let friendIds = friendItems
                .compactMap({ $0?.friendId })
                .map({ UserId(string: $0) })

            self.getUsers(by: friendIds, completion: completion)
        }
    }
    
    func searchUsers(searchString: String, completion: @escaping (JFLib.Result<[User]>) -> ()) {
        let fn = ModelUserFilterInput(firstName: ModelStringFilterInput(beginsWith: searchString))
        let ln = ModelUserFilterInput(lastName: ModelStringFilterInput(beginsWith: searchString))
        let filter = ModelUserFilterInput(or: [fn, ln])
        appSyncClient.fetch(query: ListUsersQuery(filter: filter), cachePolicy: .returnCacheDataAndFetch) { result, error in
            if let error = self.hasError(result: result, error: error) {
                completion(.failure(error))
                return
            }
            
            guard let listUsers = result?.data?.listUsers?.items else {
                completion(.success([]))
                return
            }
            
            let users = listUsers.compactMap { $0?.toUser() }
            completion(.success(users))
        }
    }
    
    func addFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (JFLib.Result<User>) -> ()) {
        let input = CreateFriendshipInput(friendId: friendId.asString, friendshipUserId: owningUserId.asString)
        appSyncClient.perform(mutation: CreateFriendshipMutation(input: input)) { result, error in
            self.getUser(friendId, completion: completion)
        }
    }
    
    func removeFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (EmptyResult) -> ()) {
        getUser(owningUserId) { result in
            switch result {
            case .success(let user):
                if let friend = user.friends.filter({ $0.friendId == friendId }).first {
                    self.deleteFriendship(id: friend.id, completion: completion)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getUserById(_ id: UserId, completion: @escaping (JFLib.Result<User?>) -> ()) {
        appSyncClient.fetch(query: GetUserQuery(id: id.asString), cachePolicy: .returnCacheDataAndFetch) { (result, error) in
            if let error = self.hasError(result: result, error: error) {
                completion(.failure(error))
                return
            }

            guard let getUser = result?.data?.getUser else {
                completion(.success(nil))
                return
            }
            
            let user = getUser.toUser()
            completion(.success(user))
        }
    }
    
    func isFriendOf(userId: UserId, otherUserId: UserId, completion: @escaping (JFLib.Result<Bool>) -> ()) {
        getUser(userId) { result in
            switch result {
            case .success(let user): completion(.success(user.isFriendsWith(otherUserId)))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}

extension GetUserQuery.Data.GetUser {
    func toUser() -> User {
        var user = User(id: UserId(string: id), emailAddress: email)
        user.firstName = firstName
        user.lastName = lastName
        if let friendItems = friends?.items {
            user.friends = friendItems.compactMap { $0?.toFriend() }
        }
        return user
    }
}

extension GetUserQuery.Data.GetUser.Friend.Item {
    func toFriend() -> Friendship {
        return Friendship(id: id, userId: UserId(string: id), friendId: UserId(string: friendId))
    }
}

extension ListUsersQuery.Data.ListUser.Item {
    func toUser() -> User {
        let userId = UserId(string: id)
        var user = User(id: userId, emailAddress: email)
        user.firstName = firstName
        user.lastName = lastName
//        if let friendItems = friends?.items {
//            let friends = friendItems.compactMap { $0?.toFriend() }
//            for friend in friends {
//                user.addFriend(friend.friendId)
//            }
//        }
        return user
    }
}

//extension ListUsersQuery.Data.ListUser.Item.Friend.Item {
//    func toFriend() -> Friendship {
//        return Friendship(userId: UserId(string: id), friendId: UserId(string: friendId))
//    }
//}
