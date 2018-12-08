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

class MockWineImageWorker: WineImageWorker {
    init() {
        super.init(imageRepository: MockWineImageRepository(), wineRepository: MockWineRepository())
    }
}

class MockWineImageRepository: WineImageRepository {
    func fetchThumbnail(wineId: UUID, userId: UserId, completion: @escaping (Result<Data?>) -> ()) {
        
    }
    
    func store(wineId: UUID, image: Data, thumbnail: Data) {
        
    }
    
    func fetchThumbnail(wineId: UUID, completion: @escaping (Result<Data?>) -> ()) {
        
    }
    
    func fetchPhoto(wineId: UUID, completion: @escaping (Result<Data?>) -> ()) {
        
    }
    
    func deleteImages(wineId: UUID) {
        
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

