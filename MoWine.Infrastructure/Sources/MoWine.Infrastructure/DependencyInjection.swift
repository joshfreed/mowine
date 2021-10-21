//
//  DependencyInjection.swift
//  
//
//  Created by Josh Freed on 10/21/21.
//

import Foundation
import Dip
import MoWine_Application
import MoWine_Domain

public class DependencyInjection {
    public static func registerServices(container: DependencyContainer) {
        container.register { UIImageResizer() }.implements(ImageResizer.self)
        container.register(.singleton) { MemoryWineTypeRepository() }.implements(WineTypeRepository.self)

        registerSocialSignInProviders(container: container)
    }

    public static func registerFirebaseServices(container: DependencyContainer) {
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

    private static func registerSocialSignInProviders(container: DependencyContainer) {
        let registry: SocialSignInRegistryImpl = try! container.resolve()

        registry.registerMethod(SignInWithApple(), for: .apple)
        registry.registerMethod(SignInWithFacebook(), for: .facebook)
        registry.registerMethod(SignInWithGoogle(), for: .google)

        registry.registerProvider(AppleProvider(), for: .apple)
        registry.registerProvider(FacebookProvider(fbGraphApi: GraphApi()), for: .facebook)
        registry.registerProvider(GoogleProvider(), for: .google)
    }
}
