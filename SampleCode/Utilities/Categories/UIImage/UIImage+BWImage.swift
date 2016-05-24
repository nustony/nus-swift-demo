//
//  UIImage+BWImage.h
//  Created by NUS Technology on 03/09/2013.
//  Copyright (c) 2013 Sample Code. All rights reserved.
//
import UIKit
extension UIImage {
    func bwImage() -> UIImage {
        var originalImage: UIImage = self
        var colorSapce: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()
        var context: CGContextRef = CGBitmapContextCreate(nil, originalImage.size.width, originalImage.size.height, 8, originalImage.size.width, colorSapce, kCGImageAlphaNone & kCGImageAlphaPremultipliedFirst)
        CGContextSetInterpolationQuality(context, .High)
        CGContextSetShouldAntialias(context, false)
        CGContextDrawImage(context, CGRectMake(0, 0, originalImage.size.width, originalImage.size.height), originalImage.CGImage)
        var bwImage: CGImageRef = CGBitmapContextCreateImage(context)
        CGContextRelease(context)
        CGColorSpaceRelease(colorSapce)
        var resultImage: UIImage = UIImage.imageWithCGImage(bwImage)
            // This is result B/W image.
        CGImageRelease(bwImage)
        return resultImage
    }
}
//
//  UIImage+BWImage.m
//  Created by NUS Technology on 03/09/2013.
//  Copyright (c) 2013 Sample Code. All rights reserved.