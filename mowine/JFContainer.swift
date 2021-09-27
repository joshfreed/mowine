//
//  Container.swift
//  mowine
//
//  Created by Josh Freed on 2/20/18.
//  Copyright © 2018 BleepSmazz. All rights reserved.
//

import Foundation
import Dip
import Combine
import Model

class JFContainer: ObservableObject {
    static private(set) var shared: JFContainer!
    
    let container: DependencyContainer
    let configurators: [Configurator]
    
    lazy var session: Session = try! container.resolve()
    lazy var emailAuthService: EmailAuthenticationService = try! container.resolve()
    lazy var wineTypeRepository: WineTypeRepository = try! container.resolve()
    lazy var wineRepository: WineRepository = try! container.resolve()
    lazy var wineImageWorker: WineImageWorkerProtocol = try! container.resolve()
    lazy var userRepository: UserRepository = try! container.resolve()
    lazy var wineImageLoader: ImageLoader = try! container.resolve()
    
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
        let configurators: [Configurator] = [
            FirebaseConfigurator(useEmulator: true)
        ]
        shared = JFContainer(container: container, configurators: configurators)
    }
    
    static func configureForPreviews() {
        let container = DependencyContainer.configureForPreviews()
        let configurators: [Configurator] = []
        shared = JFContainer(container: container, configurators: configurators)
    }
    
    func resolve<T>() throws -> T {
        try container.resolve()
    }

    static func socialSignInMethods() -> [SocialProviderType: SocialSignInMethod] {
        [
            .apple: SignInWithApple(),
            .facebook: SignInWithFacebook(),
            .google: SignInWithGoogle()
        ]
    }

    static func socialSignInProviders() -> [SocialProviderType: SocialSignInProvider] {
        [
            .apple: AppleProvider(),
            .facebook: FacebookProvider(fbGraphApi: GraphApi()),
            .google: GoogleProvider()
        ]
    }
}

// MARK: DIP

extension DependencyContainer {
    static func configure(useEmulator: Bool = false) -> DependencyContainer {
        DependencyContainer { container in
            addFirebaseServices(container: container)
            addImageServices(container: container, useEmulator: useEmulator)
            configureCommonServices(container: container)
        }
    }
    
    static func configureForUITesting() -> DependencyContainer {
        Self.configure(useEmulator: true)
    }
    
    static func configureForPreviews() -> DependencyContainer {
        DependencyContainer { container in
            container.register(.singleton) { FakeSession() }.implements(Session.self)
            container.register(.singleton) { FakeEmailAuth() as EmailAuthenticationService }
            container.register(.singleton) { FakeUserRepository() }.implements(UserRepository.self)
            container.register(.singleton) { MemoryWineRepository() as WineRepository }
            container.register(.singleton) { FakeSocialAuth() as SocialAuthService }
            
            addFakeImageServices(container: container)
            configureCommonServices(container: container)
        }
    }
    
    static func addFirebaseServices(container: DependencyContainer) {
        // Firebase Auth
        container.register(.singleton) { FirebaseEmailAuth() as EmailAuthenticationService }
        container.register(.singleton) { FirebaseSession() as Session }
        container.register(.singleton) { FirebaseCredentialMegaFactory() }
        container.register(.singleton) { FirebaseSocialAuth(credentialFactory: $0) as SocialAuthService }
        
        // Firebase Firestore
        container.register(.singleton) { FirestoreUserRepository() as UserRepository }
        container.register(.singleton) { FirestoreWineRepository() as WineRepository }
    }

    static func addImageServices(container: DependencyContainer, useEmulator: Bool) {
        container.register(.singleton) { FirebaseStorageService(useEmulator: useEmulator) }

        container.register(.singleton) { FirebaseStorageLoader(storage: $0) }
            .implements(ImageLoader.self)

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
    }

    static func addFakeImageServices(container: DependencyContainer) {
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
        container.register(.singleton) { AssetImageLoader() }
            .implements(ImageLoader.self)
    }
    
    /// Configures services who don't require fakes while UI testing. These service definitions are the same for both dev, prod, and UI testing.
    static func configureCommonServices(container: DependencyContainer) {
        // Infrastructure Layer
        container.register(.singleton) { UrlSessionService() }


        // UI Layer
        container.register(.singleton) { EditProfileService(session: $0, profilePictureWorker: $1, userProfileService: $2, userRepository: $3) }


        // Application Layer
        // Auth
        container.register { SocialUserCreator(userRepository: $0, session: $1) }
        container.register(.unique) {
            SocialAuthApplicationService(auth: $0, userFactory: $1, methods: JFContainer.socialSignInMethods(), providers: JFContainer.socialSignInProviders())
        }
        // Users
        container.register(.unique) { GetUserCellarQuery(wineTypeRepository: $0, wineRepository: $1) }
        container.register(.singleton) { GetMyAccountQueryHandler(userRepository: $0, session: $1) }.implements(GetMyAccountQuery.self)
        container.register(.singleton) { UsersService(session: $0, userRepository: $1) }
        // Wines
        container.register(.unique) { UpdateWineCommandHandler(wineRepository: $0, imageWorker: $1, wineTypeRepository: $2) }
        container.register(.unique) { DeleteWineCommandHandler(wineRepository: $0) }
        container.register(.unique) { GetWineImageQueryHandler(imageWorker: $0) }
        container.register(.unique) { GetWineByIdQueryHandler(wineRepository: $0) }
        container.register(.unique) { GetWineTypesQueryHandler(wineTypeRepository: $0) }
        container.register(.singleton) { GetTopWinesQuery(wineRepository: $0) }
        container.register(.singleton) { GetUserWinesByTypeQuery(wineRepository: $0) }
        container.register(.singleton) { GetWineDetailsQuery(wineRepository: $0) }
        container.register(.singleton) { MyWinesService(session: $0, wineTypeRepository: $1, wineRepository: $2) }
        container.register(.singleton) { WineWorker(wineRepository: $0, imageWorker: $1, session: $2) }
        container.register(.unique) { SearchMyCellarQuery(wineRepository: $0, session: $1) }
        // Friends
        container.register(.singleton) { FriendsService(session: $0, userRepository: $1) }
        // Auth
        container.register(.unique) { SignOutCommand(session: $0) }
        container.register(.unique) { SignUpWorker(emailAuthService: $0, userRepository: $1, session: $2) }


        // Domain Layer
        container.register(.singleton) { UserProfileService(session: $0, userRepository: $1, profilePictureWorker: $2) }
        container.register(.singleton) { MemoryWineTypeRepository() }.implements(WineTypeRepository.self)
    }
}
