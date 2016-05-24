//
//  UIColor+ConvertWithHex.h
//
//  Created by NUS Technology on 10/21/14.
//  Copyright (c) 2014 Sample Code, LLC. All rights reserved.
//
import UIKit
extension UIColor {
    class func colorWithHexString(hexString: String) -> UIColor {
        var rgbValue: UInt = 0
        var scanner: NSScanner = NSScanner.scannerWithString(hexString)
        scanner.scanLocation = 1
        scanner.scanHexInt(rgbValue)
        return UIColor(red: ((rgbValue & 0xFF0000) >> 16) / 255.0, green: ((rgbValue & 0xFF00) >> 8) / 255.0, blue: (rgbValue & 0xFF) / 255.0, alpha: 1.0)
    }

    class func hexStringFromUIColor(color: UIColor) -> String {
        if !color {
            return ""
        }
        if color == UIColor.whiteColor() {
            // Special case, as white doesn't fall into the RGB color space
            return "ffffff"
        }
            var red: CGFloat
            var blue: CGFloat
            var green: CGFloat
            var alpha: CGFloat
        color.getRed(red, green: green, blue: blue, alpha: alpha)
        var redDec: Int = Int(red * 255)
        var greenDec: Int = Int(green * 255)
        var blueDec: Int = Int(blue * 255)
        var hexString: String = String(format: "%02x%02x%02x", UInt(redDec), UInt(greenDec), UInt(blueDec))
        return hexString
    }
}
//
//  UIColor+ConvertWithHex.m
//
//  Created by NUS Technology on 10/21/14.
//  Copyright (c) 2014 Sample Code, LLC. All rights reserved.
//