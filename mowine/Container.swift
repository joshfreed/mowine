//
//  Container.swift
//  mowine
//
//  Created by Josh Freed on 2/20/18.
//  Copyright © 2018 BleepSmazz. All rights reserved.
//

import Foundation
import CoreData
import AWSDynamoDB

class Container {
    static let shared = Container()
    private init() {}

    lazy var session: Session = AWSContainer.shared.session
    lazy var emailAuthService: EmailAuthenticationService = AWSContainer.shared.emailAuthService
    lazy var facebookAuthService: FacebookAuthenticationService = AWSContainer.shared.facebookService
    lazy var fbGraphApi: GraphApi = GraphApi()    
    lazy var wineTypeRepository: WineTypeRepository = MemoryWineTypeRepository()
    lazy var wineRepository = AWSContainer.shared.wineRepository
    lazy var wineImageWorker: WineImageWorker = WineImageWorker()
    lazy var userRepository: UserRepository = AWSContainer.shared.userRepository
    
    // MARK: Core Data Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "mowine")
        print(NSPersistentContainer.defaultDirectoryURL())
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

// MARK: AWS Services

class AWSContainer {
    static let shared = AWSContainer()
    private init() {}
    
    lazy var session = AWSSession(userRepository: Container.shared.userRepository)
    lazy var emailAuthService = AWSEmailAuthenticationService()
    lazy var facebookService = AWSFacebookAuthentication()
    lazy var userRepository = AWSUserRepository(dynamoDbObjectMapper: AWSDynamoDBObjectMapper.default())
    lazy var wineRepository = AWSWineRepository(dynamoDbObjectMapper: AWSDynamoDBObjectMapper.default())
}
