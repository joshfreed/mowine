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
    
    private let container: DependencyContainer
    let configurators: [Configurator]
    
    lazy var session: Session = try! container.resolve()
    lazy var emailAuthService: EmailAuthenticationService = try! container.resolve()
    lazy var wineTypeRepository: WineTypeRepository = try! container.resolve()
    lazy var wineRepository: WineRepository = try! container.resolve()
    lazy var userRepository: UserRepository = try! container.resolve()
    
    private init(container: DependencyContainer, configurators: [Configurator]) {
        self.container = container
        self.configurators = configurators
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

// MARK: - Prod/Dev

extension JFContainer {
    static func configure() {
        let container = DependencyContainer.configure()
        DependencyContainer.uiContainers = [container]
        let configurators: [Configurator] = [
            FirebaseConfigurator()
        ]
        shared = JFContainer(container: container, configurators: configurators)
    }
}

extension DependencyContainer {
    static func configure() -> DependencyContainer {
        DependencyContainer { container in
            addFirebaseServices(container: container)
            configureCommonServices(container: container)
        }
    }
}

// MARK: Common Services

extension DependencyContainer {
    /// Configures services who don't require fakes while UI testing. These service definitions are the same for both dev, prod, and UI testing.
    static func configureCommonServices(container: DependencyContainer) {
        // Infrastructure Layer
        container.register { UIImageResizer() }.implements(ImageResizer.self)


        // UI Layer


        // Application Layer
        // Auth
        container.register { SocialUserCreator(userRepository: $0, session: $1) }
        container.register(.unique) {
            SocialAuthApplicationService(auth: $0, userFactory: $1, methods: JFContainer.socialSignInMethods(), providers: JFContainer.socialSignInProviders())
        }
        container.register(.unique) { SignOutCommand(session: $0) }
        container.register(.unique) { EmailAuthApplicationService(emailAuthService: $0, userRepository: $1, session: $2) }
        // Users
        container.register(.unique) { GetUserCellarQuery(wineTypeRepository: $0, wineRepository: $1) }
        container.register(.singleton) { GetMyAccountQueryHandler(userRepository: $0, session: $1) }.implements(GetMyAccountQuery.self)
        container.register(.singleton) { UsersService(session: $0, userRepository: $1) }
        container.register { UpdateProfileCommandHandler(session: $0, userRepository: $1, createProfilePicture: $2) }
        container.register { CreateProfilePictureCommandHandler(userImageStorage: $0, imageResizer: $1, userRepository: $2) }
        // Wines
        container.register(.unique) { UpdateWineCommandHandler(wineRepository: $0, wineTypeRepository: $1, createWineImages: $2) }
        container.register(.unique) { DeleteWineCommandHandler(wineRepository: $0) }
        container.register(.unique) { GetWineImageQueryHandler(wineImageStorage: $0) }
        container.register(.unique) { GetWineThumbnailQueryHandler(wineImageStorage: $0) }
        container.register(.unique) { GetWineByIdQueryHandler(wineRepository: $0) }
        container.register(.unique) { GetWineTypesQueryHandler(wineTypeRepository: $0) }
        container.register(.singleton) { GetTopWinesQuery(wineRepository: $0) }
        container.register(.singleton) { GetUserWinesByTypeQuery(wineRepository: $0) }
        container.register(.singleton) { GetWineDetailsQuery(wineRepository: $0) }
        container.register(.singleton) { MyWinesService(session: $0, wineTypeRepository: $1, wineRepository: $2) }
        container.register(.singleton) { CreateWineCommandHandler(wineRepository: $0, session: $1, createWineImages: $2) }
        container.register(.unique) { SearchMyCellarQuery(wineRepository: $0, session: $1) }
        container.register(.unique) { CreateWineImagesCommandHandler(wineImageStorage: $0, imageResizer: $1) }
        // Friends
        container.register(.singleton) { FriendsService(session: $0, userRepository: $1) }


        // Domain Layer
        container.register(.singleton) { MemoryWineTypeRepository() }.implements(WineTypeRepository.self)
    }
}

// MARK: Firebase

extension DependencyContainer {
    static func addFirebaseServices(container: DependencyContainer) {
        // Firebase Auth
        container.register(.singleton) { FirebaseEmailAuth() as EmailAuthenticationService }
        container.register(.singleton) { FirebaseSession() as Session }
        container.register(.singleton) { FirebaseCredentialMegaFactory() }
        container.register(.singleton) { FirebaseSocialAuth(credentialFactory: $0) as SocialAuthService }

        // Firebase Firestore
        container.register(.singleton) { FirestoreUserRepository() as UserRepository }
        container.register(.singleton) { FirestoreWineRepository() as WineRepository }

        // Firebase Storage
        container.register(.singleton) { FirebaseStorageService() }
        container.register { FirebaseWineImageStorage(storage: $0, session: $1) }.implements(WineImageStorage.self)
        container.register { FirebaseUserImageStorage(storage: $0) }.implements(UserImageStorage.self)
    }
}


// MARK: - UI Testing

extension JFContainer {
    static func configureForUITesting() {
        let container = DependencyContainer.configure()
        let configurators: [Configurator] = [
            FirebaseConfigurator(useEmulator: true)
        ]
        shared = JFContainer(container: container, configurators: configurators)
    }
}


// MARK: - Previews

extension JFContainer {
    static func configureForPreviews() {
        let container = DependencyContainer.configureForPreviews()
        let configurators: [Configurator] = []
        shared = JFContainer(container: container, configurators: configurators)
    }
}

extension DependencyContainer {
    static func configureForPreviews() -> DependencyContainer {
        DependencyContainer { container in
            container.register(.singleton) { FakeSession() }.implements(Session.self)
            container.register(.singleton) { FakeEmailAuth() as EmailAuthenticationService }
            container.register(.singleton) { FakeUserRepository() }.implements(UserRepository.self)
            container.register(.singleton) { MemoryWineRepository() as WineRepository }
            container.register(.singleton) { FakeSocialAuth() as SocialAuthService }
            container.register { AssetWineImageStorage(wineRepository: $0) }.implements(WineImageStorage.self)
            container.register { FakeUserImageStorage() }.implements(UserImageStorage.self)

            configureCommonServices(container: container)
        }
    }
}
