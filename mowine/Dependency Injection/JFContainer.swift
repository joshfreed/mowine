//
//  Container.swift
//  mowine
//
//  Created by Josh Freed on 2/20/18.
//  Copyright © 2018 BleepSmazz. All rights reserved.
//

import Foundation
import Dip
import MoWine_Application
import MoWine_Domain
import MoWine_Infrastructure

class JFContainer {
    static private(set) var shared: JFContainer!
    
    private let container: DependencyContainer

    private init(container: DependencyContainer) {
        self.container = container
    }
    
    func resolve<T>() throws -> T {
        try container.resolve()
    }
}

extension JFContainer {
    static func configure() {
        let container = DependencyContainer { container in
            MoWine_Application.DependencyInjection.registerServices(container: container)
            MoWine_Infrastructure.DependencyInjection.registerServices(container: container)
            MoWine_Infrastructure.DependencyInjection.registerFirebaseServices(container: container)
        }

        shared = JFContainer(container: container)
    }

    static func configureForPreviews() {
        let container = DependencyContainer { container in
            PreviewServices.registerServices(container: container)
            MoWine_Application.DependencyInjection.registerServices(container: container)
            MoWine_Infrastructure.DependencyInjection.registerServices(container: container)
        }

        shared = JFContainer(container: container)
    }
}
