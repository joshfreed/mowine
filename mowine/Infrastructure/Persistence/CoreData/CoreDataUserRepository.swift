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
    let coreData: CoreDataService
    
    init(container: NSPersistentContainer, coreData: CoreDataService) {
        self.container = container
        self.coreData = coreData
    }
    
    func saveUser(user: User, completion: @escaping (Result<User>) -> ()) {
        var managedUser = coreData.findManagedUser(by: user.id)
        
        if (managedUser == nil) {
            managedUser = ManagedUser(context: container.viewContext)
        }
        
        user.toManagedUser(managedUser!)
        
        do {
            try container.viewContext.save()
            completion(.success(user))
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func getUserById(_ id: UserId, completion: @escaping (Result<User?>) -> ()) {
        let request: NSFetchRequest<ManagedUser> = ManagedUser.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", id.asString)
        
        do {
            if let managedUser = try container.viewContext.fetch(request).first {
                let user = User.fromCoreData(managedUser)
                completion(.success(user))
            } else {
                completion(.success(nil))
            }
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func searchUsers(searchString: String, completion: @escaping (Result<[User]>) -> ()) {
        let request: NSFetchRequest<ManagedUser> = ManagedUser.fetchRequest()
        
        var predicates: [NSPredicate] = []
        let words = searchString.lowercased().split(separator: " ")
        for word in words {
            predicates.append(NSPredicate(format: "firstName BEGINSWITH[cd] %@ OR lastName BEGINSWITH[cd] %@", String(word), String(word)))
        }
        request.predicate = NSCompoundPredicate(type: .or, subpredicates: predicates)
        
        do {
            let managedUsers = try container.viewContext.fetch(request)
            let userModels = managedUsers.compactMap { User.fromCoreData($0) }
            completion(.success(userModels))
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    private func filterUsers(searchString: String, allUsers: [User]) -> [User] {
        let words = searchString.lowercased().split(separator: " ")
        var matches: [User] = []
        
        for word in words {
            let m = allUsers.filter {
                let firstName = ($0.firstName ?? "").lowercased()
                let lastName = ($0.lastName ?? "").lowercased()
                return firstName.starts(with: word) || lastName.starts(with: word)
            }
            matches.append(contentsOf: m)
        }
        
        return matches
    }
    
    func getFriendsOf(userId: UserId, completion: @escaping (Result<[User]>) -> ()) {
        completion(.success([]))
    }

    func addFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (Result<User>) -> ()) {
        
    }
    
    func removeFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (EmptyResult) -> ()) {
        
    }
    
    func isFriendOf(userId: UserId, otherUserId: UserId, completion: @escaping (Result<Bool>) -> ()) {
        completion(.success(false))
    }
}

extension User {
    func toManagedUser(_ managedUser: ManagedUser) {
        managedUser.userId = id.asString
        managedUser.emailAddress = emailAddress
        managedUser.firstName = firstName
        managedUser.lastName = lastName
    }
    
    static func fromCoreData(_ managedUser: ManagedUser) -> User? {
        guard let userIdStr = managedUser.userId else {
            return nil
        }
        
        let userId = UserId(string: userIdStr)
        var user = User(id: userId, emailAddress: managedUser.emailAddress ?? "")
        user.firstName = managedUser.firstName
        user.lastName = managedUser.lastName
        return user
    }
}
