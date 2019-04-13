//
//  FriendsScene.swift
//  mowine
//
//  Created by Josh Freed on 12/11/18.
//  Copyright © 2018 Josh Freed. All rights reserved.
//

import Foundation
import Dip

class FriendsScene {
    static func configureDependencies(_ container: DependencyContainer) {
        container.register { FriendsViewController() }
            .implements(FriendsDisplayLogic.self)
            .resolvingProperties { container, controller in
                controller.interactor = try! container.resolve()
                controller.router = try! container.resolve()
            }
        container.register { FriendsInteractor(worker: $0, profilePictureWorker: $1) }
            .implements(FriendsBusinessLogic.self, FriendsDataStore.self)
            .resolvingProperties { container, obj in
                obj.presenter = try! container.resolve()
            }
        container.register { FriendsPresenter() }
            .implements(FriendsPresentationLogic.self)
            .resolvingProperties { container, obj in
                obj.viewController = try! container.resolve()
            }
        container.register { FriendsRouter() }
            .implements(FriendsRoutingLogic.self, FriendsDataPassing.self)
            .resolvingProperties { container, obj in
                obj.dataStore = try! container.resolve()
            }
        container.register { FriendsWorker(userRepository: $0, session: $1) }
    }
}
