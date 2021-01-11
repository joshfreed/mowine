//
//  Container.swift
//  mowine
//
//  Created by Josh Freed on 2/20/18.
//  Copyright © 2018 BleepSmazz. All rights reserved.
//

import Foundation
import Dip

class JFContainer {
    static private(set) var shared: JFContainer!
    
    let container: DependencyContainer
    let configurators: [Configurator]
    
    lazy var session: Session = try! container.resolve()
    lazy var emailAuthService: EmailAuthenticationService = try! container.resolve()
    lazy var wineTypeRepository: WineTypeRepository = try! container.resolve()
    lazy var wineRepository: WineRepository = try! container.resolve()
    lazy var wineImageWorker: WineImageWorkerProtocol = try! container.resolve()
    lazy var userRepository: UserRepository = try! container.resolve()
    
    private init(container: DependencyContainer, configurators: [Configurator]) {
        self.container = container
        self.configurators = configurators
    }
    
    static func configure() {
        let container = DependencyContainer.configure()
        DependencyContainer.uiContainers = [container]
        let configurators: [Configurator] = [
            FirebaseConfigurator()
        ]
        shared = JFContainer(container: container, configurators: configurators)
    }
    
    static func configureForUITesting() {
        let container = DependencyContainer.configureForUITesting()
        let configurators: [Configurator] = []
        shared = JFContainer(container: container, configurators: configurators)
    }
    
    func firstTimeWorker() -> FirstTimeWorker {
        let userRepository: UserRepository = try! JFContainer.shared.container.resolve()
        let session: Session = try! JFContainer.shared.container.resolve()
        let socialAuthService: SocialAuthService = try! JFContainer.shared.container.resolve()

        let fbGraphApi: GraphApi = try! JFContainer.shared.container.resolve()
        let facebookProvider = FacebookProvider(fbGraphApi: fbGraphApi)
        let facebookSignInWorker = SocialSignInWorker(userRepository: userRepository, session: session, provider: facebookProvider, socialAuthService: socialAuthService)

        let googleProvider = GoogleProvider()
        let googleSignInWorker = SocialSignInWorker(userRepository: userRepository, session: session, provider: googleProvider, socialAuthService: socialAuthService)

        let appleProvider = AppleProvider()
        let appleSignInWorker = SocialSignInWorker(userRepository: userRepository, session: session, provider: appleProvider, socialAuthService: socialAuthService)

        let workers: [SocialProviderType: SocialSignInWorker] = [
            .apple: appleSignInWorker,
            .facebook: facebookSignInWorker,
            .google: googleSignInWorker
        ]

        return FirstTimeWorker(workers: workers)
    }

    func socialSignInMethods() -> [SocialProviderType: SocialSignInMethod] {
        [
            .apple: SignInWithApple(),
            .facebook: SignInWithFacebook(),
            .google: SignInWithGoogle()
        ]
    }
}

// MARK: DIP

extension DependencyContainer {
    static func configure() -> DependencyContainer {
        DependencyContainer { container in
            container.register(.singleton) { FirebaseEmailAuth() as EmailAuthenticationService }
            container.register(.singleton) { FirebaseSession() as Session }
            container.register(.singleton) { FirestoreUserRepository() as UserRepository }
            container.register(.singleton) { FirestoreWineRepository() as WineRepository }
            container.register(.singleton) { FirebaseStorageService() }
            container.register(.singleton) { FirebaseCredentialMegaFactory() }
            container.register(.singleton) { FirebaseSocialAuth(credentialFactory: $0) as SocialAuthService }
            
            // Images
            container.register(.singleton) {
                WineImageWorker<DataService<FirebaseStorageService, FirebaseStorageService>>(session: $0, wineRepository: $1, imageService: $2)
            }
                .implements(WineImageWorkerProtocol.self, WineListThumbnailFetcher.self)

            container.register(.singleton) { DataService<UrlSessionService, FirebaseStorageService>(remoteRead: $0, remoteWrite: $1) }
            container.register(.singleton) { DataService<FirebaseStorageService, FirebaseStorageService>(remoteRead: $0, remoteWrite: $1) }
            container.register(.singleton) {
                ProfilePictureWorker<DataService<UrlSessionService, FirebaseStorageService>>(session: $0, profilePictureService: $1, userRepository: $2)
            }
                .implements(ProfilePictureWorkerProtocol.self)
            
            // Common
            DependencyContainer.configureCommonServices(container: container)
        }
    }
    
    static func configureForUITesting() -> DependencyContainer {
        DependencyContainer { container in
            container.register(.singleton) { FakeSession() }.implements(Session.self)
            container.register(.singleton) { FakeEmailAuth() as EmailAuthenticationService }
            container.register(.singleton) { FakeUserRepository() }.implements(UserRepository.self)
            container.register(.singleton) { MemoryWineRepository() as WineRepository }
            container.register(.singleton) { FakeSocialAuth() as SocialAuthService }
            
            // Images
            container.register(.singleton) { FakeDataReadService() }
            container.register(.singleton) { FakeDataWriteService() }
            container.register(.singleton) {
                WineImageWorker<DataService<FakeDataReadService, FakeDataWriteService>>(session: $0, wineRepository: $1, imageService: $2)
            }
                .implements(WineImageWorkerProtocol.self, WineListThumbnailFetcher.self)

            container.register(.singleton) { DataService<UrlSessionService, FakeDataWriteService>(remoteRead: $0, remoteWrite: $1) }
            container.register(.singleton) { DataService<FakeDataReadService, FakeDataWriteService>(remoteRead: $0, remoteWrite: $1) }
            container.register(.singleton) {
                ProfilePictureWorker<DataService<UrlSessionService, FakeDataWriteService>>(session: $0, profilePictureService: $1, userRepository: $2)
            }
                .implements(ProfilePictureWorkerProtocol.self)
            
            // Common
            DependencyContainer.configureCommonServices(container: container)
        }
    }
    
    /// Configures services who don't require fakes while UI testing. These service definitions are the same for both prod and UI testing.
    static func configureCommonServices(container: DependencyContainer) {
        container.register(.singleton) { MemoryWineTypeRepository() }.implements(WineTypeRepository.self)

        // Social
        container.register(.singleton) { GraphApi() }
        
        // Images
        container.register(.singleton) { UrlSessionService() }

        // Domain Services
        container.register(.singleton) { UserProfileService(session: $0, userRepository: $1, profilePictureWorker: $2) }
        
        // Scenes
        FriendsScene.configureDependencies(container)
        container.register(.singleton) { EditProfileService(session: $0, profilePictureWorker: $1, userProfileService: $2, userRepository: $3) }
    }
}
