//
//  WineImageWorkerProtocol.swift
//  
//
//  Created by Josh Freed on 4/24/21.
//

import Foundation

public protocol WineImageWorkerProtocol {
    func createImages(wineId: WineId, photo: WineImage?) -> Data?
    func fetchPhoto(wineId: WineId, completion: @escaping (Result<Data?, Error>) -> ())
    func fetchPhoto(wine: Wine, completion: @escaping (Result<Data?, Error>) -> ())
}
