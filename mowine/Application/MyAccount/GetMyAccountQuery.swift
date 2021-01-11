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

protocol GetMyAccountQuery {
    func getMyAccount() -> AnyPublisher<GetMyAccountQueryResponse, Error>
    func getMyAccount(completion: @escaping (Result<GetMyAccountQueryResponse, Error>) -> Void)
}

struct GetMyAccountQueryResponse {
    let fullName: String
    let emailAddress: String
    let profilePictureUrl: URL?
}

class GetMyAccountQueryHandler: GetMyAccountQuery {
    let userRepository: UserRepository
    let session: Session
    
    private var subject = CurrentValueSubject<GetMyAccountQueryResponse?, Error>(nil)
    private var listener: MoWineListenerRegistration?
    private var sessionCancellable: AnyCancellable?
    
    init(userRepository: UserRepository, session: Session) {
        SwiftyBeaver.debug("init")
        
        self.userRepository = userRepository
        self.session = session
        
        startListening()
    }
    
    deinit {
        SwiftyBeaver.debug("deinit")
        listener?.remove()
        sessionCancellable = nil
    }
    
    private func startListening() {
        sessionCancellable = session.currentUserIdPublisher
            .removeDuplicates()
            .sink(receiveValue: { [weak self] userId in
                self?.updateSubscription(userId)
            })
    }
    
    private func updateSubscription(_ userId: UserId?) {
        listener?.remove()
        
        guard let userId = userId else {
            return
        }
        
        listener = userRepository.getUserByIdAndListenForUpdates(id: userId) { [weak self] result in
            guard let strongSelf = self else { return }
            
            SwiftyBeaver.info("MyAccountWorker::getCurrentUser received new user data")
            
            if case let .success(u) = result, let user = u {
                strongSelf.subject.send(.mapResponse(user))
            }
        }
    }
    
    func getMyAccount() -> AnyPublisher<GetMyAccountQueryResponse, Error> {
        return subject
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    func getMyAccount(completion: @escaping (Result<GetMyAccountQueryResponse, Error>) -> Void) {
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
