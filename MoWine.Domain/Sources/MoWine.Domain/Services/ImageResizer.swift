//
//  ImageResizer.swift
//  
//
//  Created by Josh Freed on 10/1/21.
//

import Foundation
import CoreGraphics

public protocol ImageResizer {
    func resize(data: Data, to newSize: CGSize) throws -> Data
}
