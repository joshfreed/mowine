//
//  ObservableSession.swift
//  mowine
//
//  Created by Josh Freed on 10/19/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import MoWine_Domain
import SwiftyBeaver

public class ObservableSession: ObservableObject {
    @Published public private(set) var userId: UserId? = nil
    @Published public private(set) var isAnonymous: Bool = false

    private let session: Session
    private var cancellable: AnyCancellable?

    public init(session: Session) {
        SwiftyBeaver.debug("ObservableSession::init")
        self.session = session
        observe()
    }

    deinit {
        SwiftyBeaver.debug("ObservableSession::deinit")
    }

    private func observe() {
        cancellable = session.authStateDidChange
            .receive(on: RunLoop.main)
            .sink { [weak self] authState in
                self?.userId = authState.userId
                self?.isAnonymous = authState.isAnonymous
            }

        session.start()
    }
}
