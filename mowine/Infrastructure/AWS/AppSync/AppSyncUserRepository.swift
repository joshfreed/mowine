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
    
    func add(user: User, completion: @escaping (JFLib.Result<User>) -> ()) {
        let createUserInput = CreateUserInput(
            id: GraphQLID(user.id.asString),
            email: user.emailAddress,
            firstName: user.firstName,
            lastName: user.lastName
        )
        appSyncClient.perform(mutation: CreateUserMutation(input: createUserInput)) { result, error in
            if let error = error as? AWSAppSyncClientError {
                SwiftyBeaver.error("Error occurred: \(error.localizedDescription )")
                completion(.failure(error))
                return
            }
            if let resultError = result?.errors {
                SwiftyBeaver.error("Error saving the item on server: \(resultError)")
                completion(.failure(resultError.first!))
                return
            }
            completion(.success(user))
        }
    }
    
    func save(user: User, completion: @escaping (JFLib.Result<User>) -> ()) {
        
    }
    
    func getFriendsOf(userId: UserId, completion: @escaping (JFLib.Result<[User]>) -> ()) {
        completion(.success([]))
    }
    
    func searchUsers(searchString: String, completion: @escaping (JFLib.Result<[User]>) -> ()) {
        let fn = ModelUserFilterInput(firstName: ModelStringFilterInput(beginsWith: searchString))
        let ln = ModelUserFilterInput(lastName: ModelStringFilterInput(beginsWith: searchString))
        let filter = ModelUserFilterInput(or: [fn, ln])
        appSyncClient.fetch(query: ListUsersQuery(filter: filter), cachePolicy: .returnCacheDataAndFetch) { result, error in
            if let error = error {
                SwiftyBeaver.error("\(error)")
                SwiftyBeaver.error(error.localizedDescription)
                completion(.failure(error))
                return
            }
            
            if let listUsers = result?.data?.listUsers?.items {
                let users = listUsers.compactMap { $0?.toUser() }
                completion(.success(users))
            } else {
                completion(.success([]))
            }
        }
    }
    
    func addFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (JFLib.Result<User>) -> ()) {
        
    }
    
    func removeFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (EmptyResult) -> ()) {
        
    }
    
    func getUserById(_ id: UserId, completion: @escaping (JFLib.Result<User?>) -> ()) {
        appSyncClient.fetch(query: GetUserQuery(id: id.asString), cachePolicy: .returnCacheDataAndFetch) { (result, error) in
            if error != nil {
                SwiftyBeaver.error(error?.localizedDescription ?? "")
                completion(.failure(error!))
                return
            }
            SwiftyBeaver.debug(result!.data!)
            SwiftyBeaver.debug(result!.errors)
            
            if let getUser = result?.data?.getUser {
                let user = getUser.toUser()
                completion(.success(user))
            } else {
                completion(.success(nil))
            }
        }
    }
    
    func isFriendOf(userId: UserId, otherUserId: UserId, completion: @escaping (JFLib.Result<Bool>) -> ()) {
        
    }
}

extension GetUserQuery.Data.GetUser {
    func toUser() -> User {
        var user = User(id: UserId(string: id), emailAddress: email)
        user.firstName = firstName
        user.lastName = lastName
        return user
    }
}

extension ListUsersQuery.Data.ListUser.Item {
    func toUser() -> User {
        let userId = UserId(string: id)
        var user = User(id: userId, emailAddress: email)
        user.firstName = firstName
        user.lastName = lastName
        return user
    }
}
