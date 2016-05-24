//
//  NSNumber+Helper.h
//
//  Created by NUS Technology on 8/6/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//
import Foundation
extension NSNumber {
    func getString() -> String {
        var formatter: NSNumberFormatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterDecimalStyle
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.usesSignificantDigits = false
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        return formatter.stringFromNumber(self)
    }

    func getStringValueWithMaxDecimalLength(decimalLenght: Int) -> String {
        var formatter: NSNumberFormatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterDecimalStyle
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = decimalLenght
        formatter.usesSignificantDigits = false
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        return formatter.stringFromNumber(self)
    }
}
//
//  NSNumber+Helper.m
//
//  Created by NUS Technology on 8/6/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//