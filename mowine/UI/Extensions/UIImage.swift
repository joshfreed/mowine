//
// Created by Josh Freed on 2019-01-14.
// Copyright (c) 2019 Josh Freed. All rights reserved.
//

import UIKit
import Model

extension UIImage {
    public func resizeImage(to desiredSize: CGSize) -> UIImage? {
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

extension UIImage: WineImage {
    public func resize(to desiredSize: CGSize) -> WineImage? {
        resizeImage(to: desiredSize)
    }
}
