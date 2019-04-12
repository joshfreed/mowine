//
//  Container.swift
//  mowine
//
//  Created by Josh Freed on 2/20/18.
//  Copyright © 2018 BleepSmazz. All rights reserved.
//

import Foundation
import Dip

let useFakes = false

class JFContainer {
    static let shared = JFContainer()
    private init() {
        DependencyContainer.uiContainers = [container]
    }

    let container = DependencyContainer { container in
        if useFakes {
            container.register(.singleton) { FakeSession() as Session }
            container.register(.singleton) { FakeEmailAuth() as EmailAuthenticationService }
            container.register(.singleton) { FakeUserRepository() as UserRepository }
            container.register(.singleton) { MemoryWineRepository() as WineRepository }
        } else {
            container.register(.singleton) { FirebaseEmailAuth() as EmailAuthenticationService }
            container.register(.singleton) { FirebaseSession() as Session }
            container.register(.singleton) { FirestoreUserRepository() as UserRepository }
            container.register(.singleton) { FirestoreWineRepository() as WineRepository }
            container.register(.singleton) { FirebaseStorageService() }
        }

        // Images
        container.register(.singleton) { UrlSessionService() }
        
        container.register(.singleton) {
            WineImageWorker<DataService<FirebaseStorageService, FirebaseStorageService>>(session: $0, wineRepository: $1, imageService: $2)
        }
            .implements(WineImageWorkerProtocol.self, WineListThumbnailFetcher.self)

        container.register(.singleton) { DataService<UrlSessionService, FirebaseStorageService>(remoteRead: $0, remoteWrite: $1) }
        container.register(.singleton) { DataService<FirebaseStorageService, FirebaseStorageService>(remoteRead: $0, remoteWrite: $1) }
        container.register(.singleton) {
            ProfilePictureWorker<DataService<UrlSessionService, FirebaseStorageService>>(session: $0, profilePictureService: $1)
        }
            .implements(ProfilePictureWorkerProtocol.self)

        // Auth
        container.register(.singleton) { FirebaseSocialAuth() }
            .implements(FacebookAuthenticationService.self, GoogleAuthenticationService.self)
        
        // Scenes
        FriendsScene.configureDependencies(container)        
    }
    
    lazy var session: Session = try! container.resolve()
    lazy var emailAuthService: EmailAuthenticationService = try! container.resolve()
    lazy var facebookAuthService: FacebookAuthenticationService = try! container.resolve()
    lazy var fbGraphApi: GraphApi = GraphApi()    
    lazy var wineTypeRepository: WineTypeRepository = MemoryWineTypeRepository()
    lazy var wineRepository: WineRepository = try! container.resolve()
    lazy var wineImageWorker: WineImageWorkerProtocol = try! container.resolve()
    lazy var userRepository: UserRepository = try! container.resolve()
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
