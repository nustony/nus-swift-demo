//
//  NSDate+Helper.h
//
//  Created by NUS Technology on 8/6/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//
import Foundation
extension NSDate {
    func getStringWithStringFormat(stringFormat: String) -> String {
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en-US")
        //  @"yyyy MM dd HH:mm"]
        dateFormatter.dateFormat = stringFormat
        dateFormatter.aMSymbol = "am"
        dateFormatter.pMSymbol = "pm"
        var dateString: String = dateFormatter.stringFromDate(self)
        return dateString
    }

    func toLocalTime() -> NSDate {
        var tz: NSTimeZone = NSTimeZone.defaultTimeZone()
        var seconds: Int = tz.secondsFromGMTForDate(self)
        return NSDate(timeInterval: seconds, sinceDate: self)
    }

    func toGlobalTime() -> NSDate {
        var tz: NSTimeZone = NSTimeZone.defaultTimeZone()
        var seconds: Int = -tz.secondsFromGMTForDate(self)
        return NSDate(timeInterval: seconds, sinceDate: self)
    }

    class func calculateAge(birthDate: NSDate) -> Int {
        if !birthDate {
            return 0
        }
        var now: NSDate = NSDate()
        var ageComponents: NSDateComponents = NSCalendar.currentCalendar().components(NSYearCalendarUnit, fromDate: birthDate, toDate: now, options: 0)
        var age: Int = ageComponents.year()
        return Int(age)
    }
}
//
//  NSDate+Helper.m
//
//  Created by NUS Technology on 8/6/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//