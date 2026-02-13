//
//  SignInWithApple.swift
//  mowine
//
//  Created by Josh Freed on 12/20/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation
import AuthenticationServices
import CryptoKit
import OSLog
import MoWine_Application
import MoWine_Domain

private let logger = Logger(category: .apple)

struct AppleToken: SocialToken {
    let idTokenString: String
    let nonce: String
    let fullName: PersonNameComponents?
}

fileprivate var currentNonce: String?

public class SignInWithApple: NSObject, SocialSignInMethod, ASAuthorizationControllerDelegate {
    private var completion: ((Result<SocialToken, Error>) -> Void)!

    private func signIn(completion: @escaping (Result<SocialToken, Error>) -> Void) {
        self.completion = completion
        let nonce = randomNonceString()
        currentNonce = nonce
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }

    public func signIn() async throws -> SocialToken {
        return try await withCheckedThrowingContinuation { cont in
            signIn()  { res in
                cont.resume(with: res)
            }
        }
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                logger.warning("Unable to fetch identity token")
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                logger.warning("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            let token = AppleToken(idTokenString: idTokenString, nonce: nonce, fullName: appleIDCredential.fullName)

            completion(.success(token))
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        logger.error("Sign in with Apple errored: \(error)")
        completion(.failure(error))
    }
}

private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    var randomBytes = [UInt8](repeating: 0, count: length)
    let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
    if errorCode != errSecSuccess {
        fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
    }

    let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

    let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
    }

    return String(nonce)
}
