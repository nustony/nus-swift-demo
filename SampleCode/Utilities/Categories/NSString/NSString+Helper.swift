//
//  NSString+Number.h
//
//  Created by NUS Technology on 8/6/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//
import Foundation
extension NSString {
    func getNumberWithDecimalSeperator(decimalSeperator: String) -> Int {
        var formatter: NSNumberFormatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterDecimalStyle
        formatter.decimalSeparator = decimalSeperator
        return formatter.numberFromString(self)
    }

    func getDatewithStringFormat(stringFormat: String) -> NSDate {
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        //  @"yyyy MM dd HH:mm"]
        dateFormatter.dateFormat = stringFormat
        var dateTime: NSDate = dateFormatter.dateFromString(self)
        return dateTime
    }

    func isEmptyString() -> Bool {
        var rawString: String = self.copy()
        var whitespace: NSCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        var trimmed: String = rawString.stringByTrimmingCharactersInSet(whitespace)
        if trimmed.characters.count == 0 {
            // Text was empty or only whitespace.
            return true
        }
        return false
    }

    func includeZeroPaddingInPrefix(wholeNumberLenght: Int) -> String {
        var numberFormatter: NSNumberFormatter = NSNumberFormatter()
        numberFormatter.paddingPosition = NSNumberFormatterPadBeforePrefix
        numberFormatter.paddingCharacter = "0"
        numberFormatter.minimumIntegerDigits = wholeNumberLenght
        var number: Int = Int(CInt(self)!)
        var theString: String = numberFormatter.stringFromNumber(number)
        return theString
    }

    func toLocalTime() -> String {
            // Convert parking time to Local date
        var processDate: NSDate = self.getDatewithStringFormat(kInputDateFormat)
        var localDate: NSDate = processDate.toLocalTime()
        return localDate.getStringWithStringFormat(kInputDateFormat)
    }

    func toGlobalTime() -> String {
            // Convert parking time to GMT + 0000
        var processDate: NSDate = self.getDatewithStringFormat(kInputDateFormat)
        var globalDate: NSDate = processDate.toGlobalTime()
        return globalDate.getStringWithStringFormat(kInputDateFormat)
    }

    class func generateQRCode(qRCodeText: String) -> UIImage {
            // Get the string
        var stringToEncode: String = qRCodeText
            // Generate the image
        var qrCode: CIImage = self.createQRForString(stringToEncode)
            // Convert to an UIImage
        var qrCodeImg: UIImage = self.createNonInterpolatedUIImageFromCIImage(qrCode, withScale: 2 * UIScreen.mainScreen().scale())
        // Send the image back
        return qrCodeImg
    }

    class func getStringWithoutNull(input: String) -> String {
        if input == nil || (input is NSNull.self) {
            return ""
        }
        return input
    }

    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }

    func isValidEmail() -> Bool {
        var emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}"
        var emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluateWithObject(self)
    }

    class func createQRForString(qrString: String) -> CIImage {
            // Need to convert the string to a UTF-8 encoded NSData object
        var stringData: NSData = qrString.dataUsingEncoding(NSUTF8StringEncoding)
            // Create the filter
        var qrFilter: CIFilter = CIFilter.filterWithName("CIQRCodeGenerator")
        // Set the message content and error-correction level
        qrFilter["inputMessage"] = stringData
        qrFilter["inputCorrectionLevel"] = "L"
        // Send the image back
        return qrFilter.outputImage
    }

    class func createNonInterpolatedUIImageFromCIImage(image: CIImage, withScale scale: CGFloat) -> UIImage {
            // Render the CIImage into a CGImage
        var cgImage: CGImageRef = CIContext.contextWithOptions(nil).createCGImage(image, fromRect: image.extent)
        // Now we'll rescale using CoreGraphics
        UIGraphicsBeginImageContext(CGSizeMake(image.extent.size.width * scale, image.extent.size.width * scale))
        var context: CGContextRef = UIGraphicsGetCurrentContext()
        // We don't want to interpolate (since we've got a pixel-correct image)
        CGContextSetInterpolationQuality(context, .None)
        CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage)
            // Get the image out
        var scaledImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        // Tidy up
        UIGraphicsEndImageContext()
        CGImageRelease(cgImage)
        return scaledImage
    }
}
//
//  NSString+Number.m
//
//  Created by NUS Technology on 8/6/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//