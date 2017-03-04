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
    
    func createThumbnail(from image: UIImage) -> NSData? {
        let thumbSize = CGSize(width: 150, height: 150)
        let scale = min( thumbSize.width / image.size.width, thumbSize.height / image.size.height)
        let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        
        var thumbnail: UIImage? = image

        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        thumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let thumbnail = thumbnail {
            return UIImagePNGRepresentation(thumbnail) as NSData?
        } else {
            return nil
        }
    }
}
