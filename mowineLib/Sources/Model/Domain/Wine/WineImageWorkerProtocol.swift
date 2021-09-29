//
//  WineImageWorkerProtocol.swift
//  
//
//  Created by Josh Freed on 4/24/21.
//

import Foundation

public protocol WineImageWorkerProtocol {
    func createImages(wineId: WineId, photo: WineImage?) async throws -> Data?
    func fetchPhoto(wineId: WineId) async throws -> Data?
    func fetchPhoto(wine: Wine) async throws -> Data?
}
