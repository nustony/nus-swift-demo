//
//  PTKCardExpiry.h
//  PTKPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//
import Foundation
class PTKCardExpiry: PTKComponent {
    var month: Int {
        get {
            return Int(CInteger(month)!)
        }
    }

    var year: Int {
        get {
            if !year {
                return 0
            }
            var yearStr: String = String.stringWithString(year)
            if yearStr.length == 2 {
                var formatter: NSDateFormatter? = nil
                if !formatter {
                    formatter = NSDateFormatter()
                    formatter!.dateFormat = "yyyy"
                }
                var prefix: String = formatter!.stringFromDate(NSDate())
                prefix = prefix.substringWithRange(NSMakeRange(0, 2))
                yearStr = "\(prefix)\(yearStr)"
            }
            return Int(CInteger(yearStr)!)
        }
    }

    var formattedString: String {
        get {
            if year.length > 0 {
                return "\(month)/\(year)"
            }
            return "\(month)"
        }
    }

    var formattedStringWithTrail: String {
        get {
            if month.length == 2 && year.length == 0 {
                return "\(self.formattedString())/"
            }
            else {
                return self.formattedString()
            }
        }
    }


    class func cardExpiryWithString(string: String) -> Self {
        return self(string: string)
    }

    convenience override init(string: String) {
        if !string {
            return self(month: "", year: "")
        }
        var regex: NSRegularExpression = NSRegularExpression.regularExpressionWithPattern("^(\\d{1,2})?[\\s/]*(\\d{1,4})?", options: 0, error: nil)
        var match: NSTextCheckingResult = regex.firstMatchInString(string, options: 0, range: NSMakeRange(0, string.length))
        var monthStr: String = String.string()
        var yearStr: String = String.string()
        if match != nil {
            var monthRange: NSRange = match.rangeAtIndex(1)
            if monthRange.length > 0 {
                monthStr = string.substringWithRange(monthRange)
            }
            var yearRange: NSRange = match.rangeAtIndex(2)
            if yearRange.length > 0 {
                yearStr = string.substringWithRange(yearRange)
            }
        }
        return self(month: monthStr, year: yearStr)
    }

    func isValidLength() -> Bool {
        return month.length == 2 && (        /*_year.length == 2 || */
year.length == 4)
    }

    func isValidDate() -> Bool {
        if self.month() <= 0 || self.month() > 12 {
            return false
        }
        return self.isValidWithDate(NSDate())
    }
    var month: String
    var year: String


    convenience override init(month monthStr: String, year yearStr: String) {
        super.init()
        self.month = monthStr
            self.year = yearStr
            if month.length == 1 {
                if !((month == "0") || (month == "1")) {
                    self.month = "0\(month)"
                }
            }
    }

    func isValid() -> Bool {
        return self.isValidLength() && self.isValidDate()
    }

    func isValidWithDate(dateToCompare: NSDate) -> Bool {
        var gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        var components: NSDateComponents = gregorian.components(NSYearCalendarUnit | NSMonthCalendarUnit, fromDate: dateToCompare)
        var valid: Bool = false
        if components.year < self.year {
            valid = true
        }
        else if components.year == self.year {
            valid = components.month <= self.month
        }

        return valid
    }

    func isPartiallyValid() -> Bool {
        if self.isValidLength() {
            return self.isValidDate()
        }
        else {
            return self.month() <= 12 && year.length <= 4
        }
    }

    func expiryDate() -> NSDate {
        var components: NSDateComponents = NSDateComponents()
        components.day = 1
        components.month = self.month()
        components.year = self.year()
        var gregorian: NSCalendar? = nil
        if !gregorian {
            gregorian = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        }
            // Move to the last day of the month.
        var monthRange: NSRange = gregorian!.rangeOfUnit(.Day, inUnit: .Month, forDate: gregorian!.dateFromComponents(components))
        components.day = monthRange.length
        components.hour = 23
        components.minute = 59
        return gregorian!.dateFromComponents(components)
    }
}
//
//  PTKCardExpiry.m
//  PTKPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//