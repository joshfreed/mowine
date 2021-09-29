//
//  EmailAuthApplicationService.swift
//  
//
//  Created by Josh Freed on 9/28/21.
//

import Foundation

public class EmailAuthApplicationService {
    let emailAuthService: EmailAuthenticationService
    let userRepository: UserRepository
    let session: Session

    public init(
        emailAuthService: EmailAuthenticationService,
        userRepository: UserRepository,
        session: Session
    ) {
        self.emailAuthService = emailAuthService
        self.userRepository = userRepository
        self.session = session
    }

    public func signUp(emailAddress: String, password: String, fullName: String) async throws {
        try await emailAuthService.signUp(emailAddress: emailAddress, password: password)

        guard let currentUserId = session.currentUserId else {
            throw SessionError.notLoggedIn
        }

        guard try await userRepository.getUserById(currentUserId) == nil else {
            return
        }

        var user = User(id: currentUserId, emailAddress: emailAddress)
        user.fullName = fullName
        try await userRepository.add(user: user)
    }

    public func signIn(emailAddress: String, password: String) async throws {
        try await emailAuthService.signIn(emailAddress: emailAddress, password: password)
    }

    public func forgotPassword(emailAddress: String) async throws {
        
    }
}
