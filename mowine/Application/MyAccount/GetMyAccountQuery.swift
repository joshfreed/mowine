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

class GetMyAccountQuery {
    let userRepository: UserRepository
    let session: Session
    
    private var subject = CurrentValueSubject<UserDto?, Error>(nil)
    private var listener: MoWineListenerRegistration?
    
    init(userRepository: UserRepository, session: Session) {
        SwiftyBeaver.debug("init")
        self.userRepository = userRepository
        self.session = session
    }
    
    deinit {
        SwiftyBeaver.debug("deinit")
        listener?.remove()
    }
    
    func getMyAccount() -> AnyPublisher<UserDto, Error> {
        if listener == nil, let currentUserId = session.currentUserId {
            listener = registerListener(currentUserId)
        }
        
        return subject
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    private func registerListener(_ currentUserId: UserId) -> MoWineListenerRegistration {
        userRepository.getUserByIdAndListenForUpdates(id: currentUserId) { [weak self] result in
            guard let strongSelf = self else { return }
            
            SwiftyBeaver.info("MyAccountWorker::getCurrentUser received new user data")
            
            if case let .success(u) = result, let user = u {
                strongSelf.subject.send(strongSelf.toDto(user))
            }
        }
    }
}

extension GetMyAccountQuery {
    struct UserDto {
        let fullName: String
        let emailAddress: String
        let profilePictureUrl: URL?
    }
    
    func toDto(_ user: User) -> UserDto {
        UserDto(fullName: user.fullName, emailAddress: user.emailAddress, profilePictureUrl: user.profilePictureUrl)
    }
}
