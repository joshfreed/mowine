//
//  MockWineImageWorker.swift
//  MockWineImageWorker
//
//  Created by Josh Freed on 9/8/21.
//

import Foundation
import Model

class MockWineImageWorker: WineImageWorkerProtocol {
    func createImages(wineId: WineId, photo: WineImage?) async throws -> Data? {
        nil
    }
}
