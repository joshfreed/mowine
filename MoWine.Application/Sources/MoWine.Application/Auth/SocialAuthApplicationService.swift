import Foundation
import MoWine_Domain

public class SocialAuthApplicationService {
    let auth: SocialAuthService
    let userFactory: SocialUserCreator
    let socialSignIn: SocialSignInRegistry

    public init(
        auth: SocialAuthService,
        userFactory: SocialUserCreator,
        socialSignIn: SocialSignInRegistry
    ) {
        self.auth = auth
        self.userFactory = userFactory
        self.socialSignIn = socialSignIn
    }

    public func signIn(using type: SocialProviderType) async throws {
        guard let method =  socialSignIn.getSignInMethod(for: type) else {
            fatalError("No sign in method registered for provider: \(type)")
        }

        let token = try await method.signIn()

        try await auth.signIn(with: token)

        guard let provider = socialSignIn.getSignInProvider(for: type) else {
            fatalError("No sign in provider registered for provider: \(type)")
        }

        try await userFactory.findOrCreateUserObjectForCurrentSession(from: provider)
    }
}
