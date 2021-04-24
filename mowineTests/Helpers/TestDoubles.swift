//
//  TestDoubles.swift
//  mowine
//
//  Created by Josh Freed on 6/4/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import Foundation
@testable import mowine
import UIKit
import Model

class MockWineImageWorker: WineImageWorkerProtocol {
    func fetchPhoto(wine: Wine, completion: @escaping (Result<Data?, Error>) -> ()) {
        
    }
    
    func createImages(wineId: WineId, photo: UIImage?) -> Data? {
        return nil
    }
    
    func fetchPhoto(wineId: WineId, completion: @escaping (Result<Data?, Error>) -> ()) {
        
    }
    
    func fetchThumbnail(for wine: Wine, completion: @escaping (Result<Data?, Error>) -> ()) {
        
    }
    
    func fetchThumbnail(for wineId: String, completion: @escaping (Result<Data?, Error>) -> ()) {
        
    }
}

class MockWineImageRepository: WineImageRepository {
    func fetchThumbnail(wineId: WineId, userId: UserId, completion: @escaping (Result<Data?, Error>) -> ()) {
        
    }
    
    func store(wineId: WineId, image: Data, thumbnail: Data) {
        
    }
    
    func fetchThumbnail(wineId: WineId, completion: @escaping (Result<Data?, Error>) -> ()) {
        
    }
    
    func fetchPhoto(wineId: WineId, completion: @escaping (Result<Data?, Error>) -> ()) {
        
    }
    
    func deleteImages(wineId: WineId) {
        
    }
    
    
}
