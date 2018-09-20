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
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    func saveUser(user: User, completion: @escaping (Result<User>) -> ()) {
        _ = user.toManagedUser(context: container.viewContext)
        
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
        
    }
    
    func getFriendsOf(userId: UserId, completion: @escaping (Result<[User]>) -> ()) {
        
    }

    func addFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (Result<User>) -> ()) {
        
    }
    
    func removeFriend(owningUserId: UserId, friendId: UserId, completion: @escaping (EmptyResult) -> ()) {
        
    }
    
    func isFriendOf(userId: UserId, otherUserId: UserId, completion: @escaping (Result<Bool>) -> ()) {
        
    }
}

extension User {
    func toManagedUser(context: NSManagedObjectContext) -> ManagedUser {
        let managedUser = ManagedUser(context: context)
        managedUser.userId = id.asString
        managedUser.emailAddress = emailAddress
        managedUser.firstName = firstName
        managedUser.lastName = lastName
        return managedUser
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
