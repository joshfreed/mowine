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
import JFLib

class MockWineImageWorker: WineImageWorkerProtocol {
    func fetchPhoto(wine: Wine, completion: @escaping (Result<Data?>) -> ()) {
        
    }
    
    func createImages(wineId: WineId, photo: UIImage?) -> Data? {
        return nil
    }
    
    func fetchPhoto(wineId: WineId, completion: @escaping (Result<Data?>) -> ()) {
        
    }
    
    func fetchThumbnail(for wine: Wine, completion: @escaping (Result<Data?>) -> ()) {
        
    }
    
    func fetchThumbnail(for wineId: String, completion: @escaping (Result<Data?>) -> ()) {
        
    }
}

class MockWineImageRepository: WineImageRepository {
    func fetchThumbnail(wineId: WineId, userId: UserId, completion: @escaping (Result<Data?>) -> ()) {
        
    }
    
    func store(wineId: WineId, image: Data, thumbnail: Data) {
        
    }
    
    func fetchThumbnail(wineId: WineId, completion: @escaping (Result<Data?>) -> ()) {
        
    }
    
    func fetchPhoto(wineId: WineId, completion: @escaping (Result<Data?>) -> ()) {
        
    }
    
    func deleteImages(wineId: WineId) {
        
    }
    
    
}

class MockEditWineWorker: EditWineWorker {
    init() {
        super.init(
            wineRepository: MockWineRepository(),
            wineTypeRepository: MockWineTypeRepository(),
            imageWorker: MockWineImageWorker()
        )
    }
}
