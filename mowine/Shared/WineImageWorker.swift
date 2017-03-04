//
//  WineImageWorker.swift
//  mowine
//
//  Created by Josh Freed on 2/20/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import UIKit

class WineImageWorker: NSObject {
    func convertToPNGData(image: UIImage) -> NSData? {
        var proper: UIImage? = image
        
        if !(image.imageOrientation == .up || image.imageOrientation == .upMirrored) {
            let imgsize = image.size
            UIGraphicsBeginImageContext(imgsize)
            image.draw(in: CGRect(x: 0, y: 0, width: imgsize.width, height: imgsize.height))
            proper = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        if let proper = proper {
            return UIImagePNGRepresentation(proper) as NSData?
        } else {
            return nil
        }
    }
}
