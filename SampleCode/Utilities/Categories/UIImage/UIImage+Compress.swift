//
//  UIImage+Compress.h
//
//  Created by NUS Technology on 11/4/14.
//  Copyright (c) 2014 Sample Code, LLC. All rights reserved.
//
import UIKit
extension UIImage {
    func compressAuto(original: UIImage) -> NSData {
        var scale: CGFloat = 1.0
        var maxScale: CGFloat = original.size.width
        if maxScale < original.size.height {
            maxScale = original.size.height
        }
        while maxScale > 300 {
            scale = scale - 0.1
            maxScale = maxScale * scale
        }
        return UIImageJPEGRepresentation(original, scale)
    }

    func compressForUpload(original: UIImage, scale: CGFloat) -> UIImage {
            // Calculate new size given scale factor.
        var originalSize: CGSize = original.size
        var newSize: CGSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale)
            // Scale the original image to match the new size.
        UIGraphicsBeginImageContext(newSize)
        original.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        var compressedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return compressedImage
    }
}
//
//  UIImage+Compress.m
// Sample Code
//
//  Created by NUS Technology on 11/4/14.
//  Copyright (c) 2014 Sample Code, LLC. All rights reserved.
//