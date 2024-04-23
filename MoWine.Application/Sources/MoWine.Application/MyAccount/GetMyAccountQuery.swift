//
//  GetMyAccountQuery.swift
//  mowine
//
//  Created by Josh Freed on 11/24/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import JFLib_Mediator
import MoWine_Domain

public struct GetMyAccountQuery: JFMQuery {
    public init() {}
}

public struct GetMyAccountQueryResponse {
    public let fullName: String
    public let emailAddress: String
    public let profilePictureUrl: URL?
}

public class GetMyAccountQueryHandler: BaseQueryHandler<GetMyAccountQuery, GetMyAccountQueryResponse?> {
    private let userRepository: UserRepository
    private let session: Session

    public init(userRepository: UserRepository, session: Session) {
        self.userRepository = userRepository
        self.session = session
    }
    
    public func subscribe() -> AnyPublisher<GetMyAccountQueryResponse?, Error> {
        guard let currentUserId = session.currentUserId else {
            return Just(nil).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        guard !session.isAnonymous else {
            return Just(nil).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        return userRepository
            .getUserById(currentUserId)
            .map { user -> GetMyAccountQueryResponse? in
                if let user = user {
                    return .from(user)
                } else {
                    return nil
                }
            }
            .eraseToAnyPublisher()
    }

    public override func handle(query: GetMyAccountQuery) async throws -> GetMyAccountQueryResponse? {
        guard let currentUserId = session.currentUserId else { return nil }
        guard !session.isAnonymous else { return nil }

        if let user = try await userRepository.getUserById(currentUserId) {
            return .from(user)
        } else {
            return nil
        }
    }
}

extension GetMyAccountQueryResponse {
    static func from(_ user: User) -> GetMyAccountQueryResponse {
        GetMyAccountQueryResponse(
            fullName: user.fullName,
            emailAddress: user.emailAddress,
            profilePictureUrl: user.profilePictureUrl
        )
    }
}
