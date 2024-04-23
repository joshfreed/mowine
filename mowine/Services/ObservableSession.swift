//
//  ObservableSession.swift
//  mowine
//
//  Created by Josh Freed on 10/19/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import Combine
import MoWine_Application
import OSLog

class ObservableSession: ObservableObject {
    @Published private(set) var userId: String? = nil
    @Published private(set) var isAnonymous: Bool = false

    @Injected private var session: Session
    private var cancellable: AnyCancellable?
    private let logger = Logger(category: .ui)

    init() {
        observe()
    }

    private func observe() {
        cancellable = session.authStateDidChange
            .receive(on: RunLoop.main)
            .sink { [weak self] authState in
                self?.logger.debug("The session finished initializing")
                self?.userId = authState.userId?.asString
                self?.isAnonymous = authState.isAnonymous
            }

        session.start()
    }
}
