import Foundation

public class SocialAuthApplicationService {
    let auth: SocialAuthService
    let userFactory: SocialUserCreator
    let methods: [SocialProviderType: SocialSignInMethod]
    let providers: [SocialProviderType: SocialSignInProvider]

    public init(
        auth: SocialAuthService,
        userFactory: SocialUserCreator,
        methods: [SocialProviderType: SocialSignInMethod],
        providers: [SocialProviderType: SocialSignInProvider]
    ) {
        self.auth = auth
        self.userFactory = userFactory
        self.methods = methods
        self.providers = providers
    }

    public func signIn(using type: SocialProviderType) async throws {
        guard let method = methods[type] else {
            fatalError("No sign in method registered for provider: \(type)")
        }

        let token = try await method.signIn()

        try await auth.signIn(with: token)

        guard let provider = providers[type] else {
            fatalError("No sign in provider registered for provider: \(type)")
        }

        try await userFactory.findOrCreateUserObjectForCurrentSession(from: provider)
    }
}
