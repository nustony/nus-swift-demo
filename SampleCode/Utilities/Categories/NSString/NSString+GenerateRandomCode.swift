//
//  NSString+GenerateRandomCode.h
//
//  Created by NUS Technology on 8/4/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//
import Foundation
extension NSString {
    class func generateRandomCode(length: Int) -> String {
        var returnString: NSMutableString = NSMutableString(capacity: length)
        var numbers: String = "0123456789"
        // First number cannot be 0
        returnString.appendFormat("%C", numbers.characterAtIndex((arc4random() % (numbers.characters.count - 1)) + 1))
        for var i = 1; i < length; i++ {
            returnString.appendFormat("%C", numbers.characterAtIndex(arc4random() % numbers.characters.count))
        }
        return returnString
    }
}
//
//  NSString+GenerateRandomCode.m
//
//  Created by NUS Technology on 8/4/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//