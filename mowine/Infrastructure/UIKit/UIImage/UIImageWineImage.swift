//
//  UIImageWineImage.swift
//  mowine
//
//  Created by Josh Freed on 9/30/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import Foundation
import UIKit.UIImage
import Model

class UIImageWineImageFactory: WineImageFactory {
    func createImage(from data: Data) throws -> WineImage {
        guard let image = UIImage(data: data) else {
            throw WineImageFactoryErrors.invalidImageData
        }
        return image
    }
}

extension UIImage: WineImage {
    public func resize(to desiredSize: CGSize) -> WineImage? {
        let scale = min(desiredSize.width / size.width, desiredSize.height / size.height)
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)

        var newImage: UIImage?

        UIGraphicsBeginImageContext(newSize)
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
