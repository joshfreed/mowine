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
import AWSS3
import AWSAppSync
import AWSMobileClient
import Dip

class JFContainer {
    static let shared = JFContainer()
    private init() {
        DependencyContainer.uiContainers = [container]
    }

    let container = DependencyContainer { container in
        // Common
        container.register(.singleton) { FirebaseSession() as Session }
        container.register(.singleton) { FirestoreUserRepository() as UserRepository }
        container.register(.singleton) { FirestoreWineRepository() as WineRepository }
        container.register(.singleton) { FirebaseWineImageRepository(session: $0) as WineImageRepository }
        container.register(.singleton) { WineImageWorker(imageRepository: $0, wineRepository: $1) }
        
        // Auth
        container.register(.singleton) { FirebaseSocialAuth() }
            .implements(FacebookAuthenticationService.self, GoogleAuthenticationService.self)
        
        // Scenes
        FriendsScene.configureDependencies(container)        
    }
    
    lazy var session: Session = try! container.resolve()
    lazy var emailAuthService: EmailAuthenticationService = FirebaseEmailAuth()
    lazy var facebookAuthService: FacebookAuthenticationService = try! container.resolve()
    lazy var fbGraphApi: GraphApi = GraphApi()    
    lazy var wineTypeRepository: WineTypeRepository = MemoryWineTypeRepository()
    lazy var wineRepository: WineRepository = try! container.resolve()
    lazy var wineImageRepository: WineImageRepository = try! container.resolve()
    lazy var wineImageWorker: WineImageWorker = try! container.resolve()
    lazy var userRepository: UserRepository = try! container.resolve()
    lazy var syncManager = SyncManager()
    lazy var dynamoDbWorker = DynamoDbWorker(dynamoDbObjectMapper: AWSDynamoDBObjectMapper.default())
    lazy var coreDataWorker = CoreDataWorker()
    
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
    
    lazy var session = AWSSession(userRepository: JFContainer.shared.userRepository)
    lazy var mobileAuth = AWSMobileAuth()
    lazy var wineImageRepository = S3WineImageRepository(
        transferUtility: AWSS3TransferUtility.default(),
        session: JFContainer.shared.session
    )
    lazy var appSyncClient: AWSAppSyncClient = {
        return initializeAppSync()
    }()
    lazy var userRepository: AppSyncUserRepository = AppSyncUserRepository(appSyncClient: appSyncClient)
    lazy var wineRepository: AppSyncWineRepository = AppSyncWineRepository(appSyncClient: appSyncClient)
}

func initializeAppSync() -> AWSAppSyncClient {
    // You can choose your database location, accessible by the SDK
    let databaseURL = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent("mowine_appsync")
    
    do {
        // Initialize the AWS AppSync configuration
        let appSyncConfig = try AWSAppSyncClientConfiguration(appSyncClientInfo: AWSAppSyncClientInfo(),
                                                              userPoolsAuthProvider: { return MyCognitoUserPoolsAuthProvider() }(),
                                                              databaseURL:databaseURL)
        
        // Initialize the AWS AppSync client
        let appSyncClient = try AWSAppSyncClient(appSyncConfig: appSyncConfig)
        return appSyncClient
    } catch {
        fatalError("Error initializing appsync client. \(error)")
    }
}

class MyCognitoUserPoolsAuthProvider : AWSCognitoUserPoolsAuthProviderAsync {
    func getLatestAuthToken(_ callback: @escaping (String?, Error?) -> Void) {
        AWSMobileClient.sharedInstance().getTokens { (tokens, error) in
            if error != nil {
                callback(nil, error)
            } else {
                callback(tokens?.idToken?.tokenString, nil)
            }
        }
    }
}

// MARK: Secrets

class Secrets {
    
    struct SwiftyBeaver {
        static var appId: String { return Secrets.valueFor(key: "SwiftyBeaver.appId") }
        static var appSecret: String { return Secrets.valueFor(key: "SwiftyBeaver.appSecret") }
        static var encryptionKey: String { return Secrets.valueFor(key: "SwiftyBeaver.encryptionKey") }
    }

    static func valueFor(key: String) -> String {
        let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist")
        let plist = NSDictionary(contentsOfFile: filePath!)
        
        guard let value = plist?.object(forKey: key) as? String else {
            fatalError("Couldn't find secret for key '\(key)'")
        }
        
        return value
    }
}
