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

class MockWineImageWorker: WineImageWorker {
    override func convertToPNGData(image: UIImage) -> NSData? {
        return nil
    }
    
    override func createThumbnail(from image: UIImage) -> NSData? {
        return nil
    }
}

class MockEditWineWorker: EditWineWorker {
    init() {
        super.init(
            wineRepository: MockWineRepository(),
            wineTypeRepository: MockWineTypeRepository(),
            wineVarietyRepository: MockWineVarietyRepository(),
            imageWorker: MockWineImageWorker()
        )
    }
}

