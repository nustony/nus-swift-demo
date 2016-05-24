//
//  CardNumber.h
//  PTKPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//
import Foundation
class PTKCardNumber: PTKComponent {
    var cardType: PTKCardType {
        get {
            if number.length < 2 {
                return PTKCardTypeUnknown
            }
            var firstChars: String = number.substringWithRange(NSMakeRange(0, 2))
            var range: Int = CInteger(firstChars)!
            if range >= 40 && range <= 49 {
                return PTKCardTypeVisa
            }
            else if range >= 50 && range <= 59 {
                return PTKCardTypeMasterCard
            }
            else if range == 34 || range == 37 {
                return PTKCardTypeAmex
            }
            else if range == 60 || range == 62 || range == 64 || range == 65 {
                return PTKCardTypeDiscover
            }
            else if range == 35 {
                return PTKCardTypeJCB
            }
            else if range == 30 || range == 36 || range == 38 || range == 39 {
                return PTKCardTypeDinersClub
            }
            else {
                return PTKCardTypeUnknown
            }
    
        }
    }

    var last4: String {
        get {
            if number.length >= 4 {
                return number.substringFromIndex((number.characters.count - 4))
            }
            else {
                return nil
            }
        }
    }

    var lastGroup: String {
        get {
            if self.cardType == PTKCardTypeAmex {
                if number.length >= 5 {
                    return number.substringFromIndex((number.characters.count - 5))
                }
            }
            else {
                if number.length >= 4 {
                    return number.substringFromIndex((number.characters.count - 4))
                }
            }
            return nil
        }
    }

    var string: String {
        get {
            return number
        }
    }

    var formattedString: String {
        get {
            var regex: NSRegularExpression
            if self.cardType == PTKCardTypeAmex {
                regex = NSRegularExpression.regularExpressionWithPattern("(\\d{1,4})(\\d{1,6})?(\\d{1,5})?", options: 0, error: nil)
            }
            else {
                regex = NSRegularExpression.regularExpressionWithPattern("(\\d{1,4})", options: 0, error: nil)
            }
            var matches: [AnyObject] = regex.matchesInString(number, options: 0, range: NSMakeRange(0, number.length))
            var result: [AnyObject] = [AnyObject](minimumCapacity: matches.count)
            for match: NSTextCheckingResult in matches {
                for var i = 1; i < match.numberOfRanges(); i++ {
                    var range: NSRange = match.rangeAtIndex(i)
                    if range.length > 0 {
                        var matchText: String = number.substringWithRange(range)
                        result.append(matchText)
                    }
                }
            }
            return result.componentsJoinedByString(" ")
        }
    }

    var formattedStringWithTrail: String {
        get {
            var string: String = self.formattedString()
            var regex: NSRegularExpression
            // No trailing space needed
            if self.isValidLength() {
                return string
            }
            if self.cardType == PTKCardTypeAmex {
                regex = NSRegularExpression.regularExpressionWithPattern("^(\\d{4}|\\d{4}\\s\\d{6})$", options: 0, error: nil)
            }
            else {
                regex = NSRegularExpression.regularExpressionWithPattern("(?:^|\\s)(\\d{4})$", options: 0, error: nil)
            }
            var numberOfMatches: Int = regex.numberOfMatchesInString(string, options: 0, range: NSMakeRange(0, string.length))
            if numberOfMatches == 0 {
                // Not at the end of a group of digits
                return string
            }
            else {
                return "\(string) "
            }
        }
    }

    var valid: Bool {
        get {
            return self.isValidLength() && self.isValidLuhn()
        }
    }

    var validLength: Bool {
        get {
            return number.length == self.lengthForCardType()
        }
    }

    var validLuhn: Bool {
        get {
            var odd: Bool = true
            var sum: Int = 0
            var digits: [AnyObject] = [AnyObject](minimumCapacity: number.length)
            for var i = 0; i < number.length; i++ {
                digits.append(number.substringWithRange(NSMakeRange(i, 1)))
            }
            for digitStr: String in digits.reverseObjectEnumerator() {
                var digit: Int = CInt(digitStr)!
                if (odd = !odd) {
                    digit *= 2
                }
                if digit > 9 {
                    digit -= 9
                }
                sum += digit
            }
            return sum % 10 == 0
        }
    }

    var partiallyValid: Bool {
        get {
            return number.length <= self.lengthForCardType()
        }
    }


    class func cardNumberWithString(string: String) -> Self {
        return self(string: string)
    }

    convenience override init(string: String) {
        super.init()
        // Strip non-digits
            self.number = string.stringByReplacingOccurrencesOfString("\\D", withString: "", options: NSRegularExpressionSearch, range: NSMakeRange(0, string.length))
    }
    var number: String


    func lengthForCardType() -> Int {
        var type: PTKCardType = self.cardType
            var length: Int
        if type == PTKCardTypeAmex {
            length = 15
        }
        else if type == PTKCardTypeDinersClub {
            length = 14
        }
        else {
            length = 16
        }

        return length
    }
}
//
//  CardNumber.m
//  PTKPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//