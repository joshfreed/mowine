//
//  CoreDataUserRepository.swift
//  mowine
//
//  Created by Josh Freed on 9/19/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import JFLib
import CoreData

class CoreDataUserRepository: UserRepository {
    let container: NSPersistentContainer
    let coreDataWorker: CoreDataWorkerProtocol
    
    init(container: NSPersistentContainer, coreData: CoreDataService, coreDataWorker: CoreDataWorkerProtocol) {
        self.container = container
        self.coreDataWorker = coreDataWorker
    }
    
    func saveUser(user: User, completion: @escaping (Result<User>) -> ()) {
        do {
            if let _ = try getById(user.id) {
                try coreDataWorker.update(user, in: container.viewContext)
            } else {
                try coreDataWorker.insert(user, in: container.viewContext)
            }
            try save()
            completion(.success(user))
        } catch {
            completion(.failure(error))
        }
    }
    
    func getUserById(_ id: UserId, completion: @escaping (Result<User?>) -> ()) {
        do {
            let user: User? = try getById(id)
            completion(.success(user))
        } catch {
            completion(.failure(error))
        }
    }
    
    func searchUsers(searchString: String, completion: @escaping (Result<[User]>) -> ()) {
        var predicates: [NSPredicate] = []
        let words = searchString.lowercased().split(separator: " ")
        for word in words {
            predicates.append(NSPredicate(format: "firstName BEGINSWITH[cd] %@ OR lastName BEGINSWITH[cd] %@", String(word), String(word)))
        }
        let searchPredicate = NSCompoundPredicate(type: .or, subpredicates: predicates)
        
        do {
            let users: [User] = try coreDataWorker.get(with: searchPredicate, sortDescriptors: nil, from: container.viewContext)
            completion(.success(users))
        } catch {
            completion(.failure(error))
        }
    }

    func getFriendsOf(userId: UserId, completion: @escaping (Result<[User]>) -> ()) {
        do {
            if let user = try getById(userId) {
                let friends = try user.friends.compactMap({ try getById($0.friendId) })
                completion(.success(friends))
            } else {
                completion(.success([]))
            }
        } catch {
            completion(.failure(error))
        }
    }

    func addFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (Result<User>) -> ()) {
        do {
            guard var user = try getById(owningUserId) else {
                completion(.failure(UserRepositoryError.userNotFound))
                return
            }
            guard let friend = try getById(friendId) else {
                completion(.failure(UserRepositoryError.userNotFound))
                return
            }
            
            user.addFriend(user: friend)
            try coreDataWorker.update(user, in: container.viewContext)
            try save()
            completion(.success(friend))
        } catch {
            completion(.failure(error))
        }
    }
    
    func removeFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (EmptyResult) -> ()) {
        do {
            guard var user = try getById(owningUserId) else {
                completion(.failure(UserRepositoryError.userNotFound))
                return
            }
            guard let friend = try getById(friendId) else {
                completion(.failure(UserRepositoryError.userNotFound))
                return
            }
            
            user.removeFriend(user: friend)
            try coreDataWorker.update(user, in: container.viewContext)
            try save()
            completion(.success)
        } catch {
            completion(.failure(error))
        }
    }
    
    func isFriendOf(userId: UserId, otherUserId: UserId, completion: @escaping (Result<Bool>) -> ()) {
        do {
            guard let user = try getById(userId) else {
                completion(.failure(UserRepositoryError.userNotFound))
                return
            }
            guard let otherUser = try getById(otherUserId) else {
                completion(.failure(UserRepositoryError.userNotFound))
                return
            }
            
            let isFriendsWith = user.isFriendsWith(otherUser)
            
            completion(.success(isFriendsWith))
        } catch {
            completion(.failure(error))
        }
    }
    
    private func getById(_ userId: UserId) throws -> User? {
        return try coreDataWorker.getOne(with: NSPredicate(format: "userId == %@", userId.asString), from: container.viewContext)
    }
    
    private func save() throws {
        try container.viewContext.save()
    }
}
