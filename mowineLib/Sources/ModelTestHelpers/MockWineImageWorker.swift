//
//  MockWineImageWorker.swift
//  MockWineImageWorker
//
//  Created by Josh Freed on 9/8/21.
//

import Foundation
import Model

class MockWineImageWorker: WineImageWorkerProtocol {
    func fetchPhoto(wine: Wine, completion: @escaping (Result<Data?, Error>) -> ()) {

    }

    func createImages(wineId: WineId, photo: WineImage?) -> Data? {
        return nil
    }

    func fetchPhoto(wineId: WineId, completion: @escaping (Result<Data?, Error>) -> ()) {

    }

    func fetchThumbnail(for wine: Wine, completion: @escaping (Result<Data?, Error>) -> ()) {

    }

    func fetchThumbnail(for wineId: String, completion: @escaping (Result<Data?, Error>) -> ()) {

    }
}
