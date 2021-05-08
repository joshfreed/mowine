//
// Created by Josh Freed on 5/8/21.
//

import Foundation
import CoreGraphics

public protocol WineImage {
    func resize(to desiredSize: CGSize) -> WineImage?
    func pngData() -> Data?
}
