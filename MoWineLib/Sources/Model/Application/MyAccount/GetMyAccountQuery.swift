//
//  GetMyAccountQuery.swift
//  mowine
//
//  Created by Josh Freed on 11/24/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import SwiftyBeaver

public protocol GetMyAccountQuery {
    func getMyAccount() -> AnyPublisher<GetMyAccountQueryResponse?, Error>
    func getMyAccount() async throws -> GetMyAccountQueryResponse?
}

public struct GetMyAccountQueryResponse {
    public let fullName: String
    public let emailAddress: String
    public let profilePictureUrl: URL?
}

public class GetMyAccountQueryHandler: GetMyAccountQuery {
    private let userRepository: UserRepository
    private let session: Session
    private var subject = CurrentValueSubject<GetMyAccountQueryResponse?, Error>(nil)
    private var sessionCancellable: AnyCancellable?
    private var listener: MoWineListenerRegistration?
    
    public init(userRepository: UserRepository, session: Session) {
        SwiftyBeaver.debug("init")
        self.userRepository = userRepository
        self.session = session
    }
    
    deinit {
        SwiftyBeaver.debug("deinit")
        listener?.remove()
        sessionCancellable = nil
    }
    
    public func getMyAccount() -> AnyPublisher<GetMyAccountQueryResponse?, Error> {
        if listener == nil {
            startListening()
        }

        return subject.eraseToAnyPublisher()
    }
/*
    public func getMyAccount(completion: @escaping (Result<GetMyAccountQueryResponse, Error>) -> Void) {
        SwiftyBeaver.info("getMyAccount w/ completion")
        
        guard let currentUserId = session.currentUserId else {
            completion(.failure(SessionError.notLoggedIn))
            return
        }

        userRepository.getUserById(currentUserId) { result in
            switch result {
            case .success(let user):
                if let user = user {
                    let dto: GetMyAccountQueryResponse = .mapResponse(user)
                    completion(.success(dto))
                } else {
                    completion(.failure(UserRepositoryError.userNotFound))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
*/
    public func getMyAccount() async throws -> GetMyAccountQueryResponse? {
        SwiftyBeaver.info("getMyAccount async")

        guard let currentUserId = session.currentUserId else { return nil }
        guard !session.isAnonymous else { return nil }

        if let user = try await userRepository.getUserById(currentUserId) {
            return .mapResponse(user)
        } else {
            return nil
        }
    }
}

// MARK: Listener

extension GetMyAccountQueryHandler {
    private func startListening() {
        sessionCancellable = session.currentUserIdPublisher
            .removeDuplicates()
            .sink { [weak self] userId in
                self?.updateSubscription(userId)
            }
    }

    private func updateSubscription(_ userId: UserId?) {
        listener?.remove()

        guard let userId = userId else {
            return
        }

        listener = userRepository.getUserByIdAndListenForUpdates(id: userId) { [weak self] result in
            SwiftyBeaver.info("MyAccountWorker::getCurrentUser received new user data")

            if case let .success(u) = result, let user = u {
                self?.subject.send(.mapResponse(user))
            }
        }
    }
}

extension GetMyAccountQueryResponse {
    static func mapResponse(_ user: User) -> GetMyAccountQueryResponse {
        GetMyAccountQueryResponse(
            fullName: user.fullName,
            emailAddress: user.emailAddress,
            profilePictureUrl: user.profilePictureUrl
        )
    }
}
