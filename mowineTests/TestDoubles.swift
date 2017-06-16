//
//  TestDoubles.swift
//  mowine
//
//  Created by Josh Freed on 6/4/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import Foundation
import CoreData
@testable import mowine
import UIKit

class MockVarietyTranslator: VarietyTranslator {
    init() {
        super.init(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
    }
    
    var calledToCoreData = false
    var toCoreDataInput: String?
    var toCoreDataVarietyResult: Variety?
    override func toCoreData(input: String) -> Variety? {
        calledToCoreData = true
        toCoreDataInput = input
        return toCoreDataVarietyResult
    }
}

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
        super.init(varietyTranslator: MockVarietyTranslator(), imageWorker: MockWineImageWorker())
    }
}

class MockWineTypeWorker: WineTypeWorker {
    init() {
        super.init(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
    }
}
