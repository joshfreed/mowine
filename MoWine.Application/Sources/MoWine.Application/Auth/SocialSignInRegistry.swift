//
//  SocialSignInRegistry.swift
//  
//
//  Created by Josh Freed on 10/21/21.
//

import Foundation

public protocol SocialSignInRegistry {
    func getSignInMethod(for type: SocialProviderType) -> SocialSignInMethod?
    func getSignInProvider(for type: SocialProviderType) -> SocialSignInProvider?
}

public class SocialSignInRegistryImpl: SocialSignInRegistry {
    private var methods: [SocialProviderType: SocialSignInMethod] = [:]
    private var providers: [SocialProviderType: SocialSignInProvider] = [:]

    public init() {}

    public func registerMethod(_ provider: SocialSignInMethod, for type: SocialProviderType) {
        methods[type] = provider
    }

    public func registerProvider(_ provider: SocialSignInProvider, for type: SocialProviderType) {
        providers[type] = provider
    }

    public func getSignInMethod(for type: SocialProviderType) -> SocialSignInMethod? {
        methods[type]
    }

    public func getSignInProvider(for type: SocialProviderType) -> SocialSignInProvider? {
        providers[type]
    }
}
