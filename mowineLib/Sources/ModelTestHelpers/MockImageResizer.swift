//
//  MockImageResizer.swift
//  
//
//  Created by Josh Freed on 10/3/21.
//

import Foundation
import Model
import CoreGraphics

class MockImageResizer: ImageResizer {
    func resize(data: Data, to newSize: CGSize) throws -> Data {
        fatalError("Do not call")
    }
}