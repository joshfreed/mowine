//
//  UIImageResizer.swift
//  mowine
//
//  Created by Josh Freed on 10/1/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import UIKit
import Model

class UIImageResizer: ImageResizer {
    func resize(data: Data, to newSize: CGSize) throws -> Data {
        guard let image = UIImage(data: data) else {
            fatalError("Not an image")
        }

        guard let resizedImage = image.resize(to: newSize) else {
            fatalError("resize failed")
        }

        guard let pngData = resizedImage.pngData() else {
            fatalError("UNable to convert")
        }

        return pngData
    }
}

extension UIImage {
    public func resize(to desiredSize: CGSize) -> UIImage? {
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
