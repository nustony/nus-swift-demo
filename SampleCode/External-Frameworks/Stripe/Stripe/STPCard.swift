//
//  STPCard.h
//  Stripe
//
//  Created by Saikat Chakrabarti on 11/2/12.
//
//
import Foundation
/*
 This object represents a credit card.  You should create these and populate
 its properties with information that your customer enters on your credit card
 form.  Then you create tokens from these.
 */
class STPCard: NSObject, STPFormEncodeProtocol {
    var number: String
    var expMonth: Int
    var expYear: Int
    var cvc: String
    var name: String
    var addressLine1: String
    var addressLine2: String
    var addressCity: String
    var addressState: String
    var addressZip: String
    var addressCountry: String
    var cardId: String {
        get {
            return self.cardId
        }
    }

    var object: String {
        get {
            return self.object
        }
    }

    var last4: String {
        get {
            if last4 {
                return last4
            }
            else if self.number && self.number.length >= 4 {
                return self.number.substringFromIndex((self.number.length - 4))
            }
            else {
                return nil
            }
    
        }
    }

    var type: String {
        get {
            if type != nil {
                return type
            }
            else if self.number {
                return self.self.cardBrandFromNumber(self.number)
            }
            else {
                return nil
            }
    
        }
    }

    var fingerprint: String {
        get {
            return self.fingerprint
        }
    }

    var country: String {
        get {
            return self.country
        }
    }

    /*
     You should not use this constructor.  This constructor is used by Stripe to
     generate cards from the response of creating ar getting a token.
     */

    convenience override init(attributeDictionary: [NSObject : AnyObject]) {
        self = self()
        var dict: [NSObject : AnyObject] = NSMutableDictionary()
        attributeDictionary.enumerateKeysAndObjectsUsingBlock({(key: AnyObject, obj: AnyObject, stop: Bool) -> Void in
            if obj != NSNull() {
                dict[key] = obj
            }
        })
                self.cardId = dict["id"]
            self.number = dict["number"]
            self.cvc = dict["cvc"]
            self.name = dict["name"]
            self.object = dict["object"]
            self.last4 = dict["last4"]
            self.type = dict["type"]
            self.fingerprint = dict["fingerprint"]
            self.country = dict["country"]
            // Support both camelCase and snake_case keys
            self.expMonth = CInt((dict["exp_month"] ?? dict["expMonth"]))!
            self.expYear = CInt((dict["exp_year"] ?? dict["expYear"]))!
            self.addressLine1 = dict["address_line1"] ?? dict["addressLine1"]
            self.addressLine2 = dict["address_line2"] ?? dict["addressLine2"]
            self.addressCity = dict["address_city"] ?? dict["addressCity"]
            self.addressState = dict["address_state"] ?? dict["addressState"]
            self.addressZip = dict["address_zip"] ?? dict["addressZip"]
            self.addressCountry = dict["address_country"] ?? dict["addressCountry"]
    }

    func isEqualToCard(other: STPCard) -> Bool {
        if self == other {
            return true
        }
        if !other || !(other is self.self) {
            return false
        }
        return self.expMonth == other.expMonth && self.expYear == other.expYear && (self.number ?? "" == other.number ?? "") && (self.cvc ?? "" == other.cvc ?? "") && (self.name ?? "" == other.name ?? "") && (self.addressLine1 ?? "" == other.addressLine1 ?? "") && (self.addressLine2 ?? "" == other.addressLine2 ?? "") && (self.addressCity ?? "" == other.addressCity ?? "") && (self.addressState ?? "" == other.addressState ?? "") && (self.addressZip ?? "" == other.addressZip ?? "") && (self.addressCountry ?? "" == other.addressCountry ?? "")
    }
    /* These validation methods work as described in
        http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/KeyValueCoding/Articles/Validation.html#//apple_ref/doc/uid/20002173-CJBDBHCB
    */

    func validateNumber(ioValue: AnyObject, error outError: NSError) -> Bool {
        if ioValue == nil {
            return STPCard.handleValidationErrorForParameter("number", error: outError)
        }
        var regexError: NSError? = nil
        var ioValueString: String = String(ioValue)
        var regex: NSRegularExpression = NSRegularExpression.regularExpressionWithPattern("[\\s+|-]", options: NSRegularExpressionCaseInsensitive, error: regexError!)
        var rawNumber: String = regex.stringByReplacingMatchesInString(ioValueString, options: 0, range: NSMakeRange(0, ioValueString.characters.count), withTemplate: "")
        if rawNumber == nil || rawNumber.length < 10 || rawNumber.length > 19 || !STPCard.isLuhnValidString(rawNumber) {
            return STPCard.handleValidationErrorForParameter("number", error: outError)
        }
        return true
    }

    func validateCvc(ioValue: AnyObject, error outError: NSError) -> Bool {
        if ioValue == nil {
            return STPCard.handleValidationErrorForParameter("number", error: outError)
        }
        var ioValueString: String = String(ioValue).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        var cardType: String = self.type()
        var validLength: Bool = ((cardType == nil && ioValueString.characters.count >= 3 && ioValueString.characters.count <= 4) || ((cardType == "American Express") && ioValueString.characters.count == 4) || (!(cardType == "American Express") && ioValueString.characters.count == 3))
        if !STPCard.isNumericOnlyString(ioValueString) || !validLength {
            return STPCard.handleValidationErrorForParameter("cvc", error: outError)
        }
        return true
    }

    func validateExpMonth(ioValue: AnyObject, error outError: NSError) -> Bool {
        if ioValue == nil {
            return STPCard.handleValidationErrorForParameter("expMonth", error: outError)
        }
        var ioValueString: String = String(ioValue).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        var expMonthInt: Int = CInteger(ioValueString)!
        if (!STPCard.isNumericOnlyString(ioValueString) || expMonthInt > 12 || expMonthInt < 1) {
            return STPCard.handleValidationErrorForParameter("expMonth", error: outError)
        }
        else if self.expYear() && STPCard.isExpiredMonth(expMonthInt, andYear: self.expYear()) {
            var currentYear: Int = STPCard.currentYear()
            // If the year is in the past, this is actually a problem with the expYear parameter, but it still means this month is not a valid month. This is pretty
            // rare - it means someone set expYear on the card without validating it
            if currentYear > self.expYear() {
                return STPCard.handleValidationErrorForParameter("expYear", error: outError)
            }
            else {
                return STPCard.handleValidationErrorForParameter("expMonth", error: outError)
            }
        }

        return true
    }

    func validateExpYear(ioValue: AnyObject, error outError: NSError) -> Bool {
        if ioValue == nil {
            return STPCard.handleValidationErrorForParameter("expYear", error: outError)
        }
        var ioValueString: String = String(ioValue).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        var expYearInt: Int = CInteger(ioValueString)!
        if (!STPCard.isNumericOnlyString(ioValueString) || expYearInt < STPCard.currentYear()) {
            return STPCard.handleValidationErrorForParameter("expYear", error: outError)
        }
        else if self.expMonth() && STPCard.isExpiredMonth(self.expMonth(), andYear: expYearInt) {
            return STPCard.handleValidationErrorForParameter("expMonth", error: outError)
        }

        return true
    }
    /*
     This validates a fully populated card to check for all errors, including ones
     that come about from the interaction of more than one property. It will also do
     all the validations on individual properties, so if you only want to call one
     method on your card to validate it after setting all the properties, call this
     one.
     */

    func validateCardReturningError(outError: NSError) -> Bool {
            // Order matters here
        var numberRef: String = self.number()
        var expMonthRef: String = "\(UInt(self.expMonth()))"
        var expYearRef: String = "\(UInt(self.expYear()))"
        var cvcRef: String = self.cvc()
        // Make sure expMonth, expYear, and number are set.  Validate CVC if it is provided
        return self.validateNumber(numberRef, error: outError) && self.validateExpYear(expYearRef, error: outError) && self.validateExpMonth(expMonthRef, error: outError) && (cvcRef == nil || self.validateCvc(cvcRef, error: outError))
    }

    class func isLuhnValidString(number: String) -> Bool {
        var isOdd: Bool = true
        var sum: Int = 0
        var numberFormatter: NSNumberFormatter = NSNumberFormatter()
        for var index = number.characters.count - 1; index >= 0; index-- {
            var digit: String = number.substringWithRange(NSMakeRange(index, 1))
            var digitNumber: Int = numberFormatter.numberFromString(digit)
            if digitNumber == nil {
                return false
            }
            var digitInteger: Int = CInt(digitNumber)!
            isOdd = !isOdd
            if isOdd {
                digitInteger *= 2
            }
            if digitInteger > 9 {
                digitInteger -= 9
            }
            sum += digitInteger
        }
        return sum % 10 == 0
    }

    class func isNumericOnlyString(aString: String) -> Bool {
        var numericOnly: NSCharacterSet = NSCharacterSet.decimalDigitCharacterSet()
        var aStringSet: NSCharacterSet = NSCharacterSet(charactersInString: aString)
        return numericOnly.isSupersetOfSet(aStringSet)
    }

    class func isExpiredMonth(month: Int, andYear year: Int) -> Bool {
        var now: NSDate = NSDate()
        // Cards expire at end of month
        month = month + 1
        var calendar: NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        var components: NSDateComponents = NSDateComponents()
        components.year = year
        components.month = month
        components.day = 1
        var expiryDate: NSDate = calendar.dateFromComponents(components)
        return (expiryDate.compare(now) == NSOrderedAscending)
    }

    class func currentYear() -> Int {
        var gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        var components: NSDateComponents = gregorian.components(NSYearCalendarUnit, fromDate: NSDate())
        return components.year()
    }

    class func handleValidationErrorForParameter(parameter: String, error outError: NSError) -> Bool {
        if outError != nil {
            if (parameter == "number") {
                outError = self.createErrorWithMessage(STPCardErrorInvalidNumberUserMessage, parameter: parameter, cardErrorCode: STPInvalidNumber, devErrorMessage: "Card number must be between 10 and 19 digits long and Luhn valid.")
            }
            else if (parameter == "cvc") {
                outError = self.createErrorWithMessage(STPCardErrorInvalidCVCUserMessage, parameter: parameter, cardErrorCode: STPInvalidCVC, devErrorMessage: "Card CVC must be numeric, 3 digits for Visa, Discover, MasterCard, JCB, and Discover cards, and 4 " + 
                    "digits for American Express cards.")
            }
            else if (parameter == "expMonth") {
                outError = self.createErrorWithMessage(STPCardErrorInvalidExpMonthUserMessage, parameter: parameter, cardErrorCode: STPInvalidExpMonth, devErrorMessage: "expMonth must be less than 13")
            }
            else if (parameter == "expYear") {
                outError = self.createErrorWithMessage(STPCardErrorInvalidExpYearUserMessage, parameter: parameter, cardErrorCode: STPInvalidExpYear, devErrorMessage: "expYear must be this year or a year in the future")
            }
            else {
                // This should not be possible since this is a private method so we
                // know exactly how it is called.  We use STPAPIError for all errors
                // that are unexpected within the bindings as well.
                outError = NSError(domain: StripeDomain, code: STPAPIError, userInfo: [NSLocalizedDescriptionKey: STPUnexpectedError, STPErrorMessageKey: "There was an error within the Stripe client library when trying to generate the " + 
                    "proper validation error. Contact support@stripe.com if you see this."])
            }
        }
        return false
    }

    class func createErrorWithMessage(userMessage: String, parameter: String, cardErrorCode: String, devErrorMessage devMessage: String) -> NSError {
        return NSError(domain: StripeDomain, code: STPCardError, userInfo: [NSLocalizedDescriptionKey: userMessage, STPErrorParameterKey: parameter, STPCardErrorCodeKey: cardErrorCode, STPErrorMessageKey: devMessage])
    }

    class func cardBrandFromNumber(number: String) -> String {
        if number.hasPrefix("34") || number.hasPrefix("37") {
            return "American Express"
        }
        else if number.hasPrefix("60") || number.hasPrefix("62") || number.hasPrefix("64") || number.hasPrefix("65") {
            return "Discover"
        }
        else if number.hasPrefix("35") {
            return "JCB"
        }
        else if number.hasPrefix("30") || number.hasPrefix("36") || number.hasPrefix("38") || number.hasPrefix("39") {
            return "Diners Club"
        }
        else if number.hasPrefix("4") {
            return "Visa"
        }
        else if number.hasPrefix("5") {
            return "MasterCard"
        }
        else {
            return "Unknown"
        }

    }

    convenience override init() {
        super.init()
                self.object = "card"
    }

    func formEncode() -> NSData {
        var params: [NSObject : AnyObject] = NSMutableDictionary()
        if number != 0 {
            params["number"] = number
        }
        if cvc {
            params["cvc"] = cvc
        }
        if name! {
            params["name"] = name!
        }
        if addressLine1 {
            params["address_line1"] = addressLine1
        }
        if addressLine2 {
            params["address_line2"] = addressLine2
        }
        if addressCity {
            params["address_city"] = addressCity
        }
        if addressState {
            params["address_state"] = addressState
        }
        if addressZip {
            params["address_zip"] = addressZip
        }
        if addressCountry {
            params["address_country"] = addressCountry
        }
        if expMonth {
            params["exp_month"] = "\(UInt(expMonth))"
        }
        if expYear {
            params["exp_year"] = "\(UInt(expYear))"
        }
        var parts: [AnyObject] = NSMutableArray()
        params.enumerateKeysAndObjectsUsingBlock({(key: AnyObject, val: AnyObject, stop: Bool) -> Void in
            if val != NSNull() {
                parts.append("card[\(key)]=\(STPUtils.stringByURLEncoding(val))")
            }
        })
        return parts.componentsJoinedByString("&").dataUsingEncoding(NSUTF8StringEncoding)
    }

    func isEqual(other: AnyObject) -> Bool {
        return self.isEqualToCard(other)
    }

    var cardId: String
    var object: String
    var last4: String {
        get {
            if last4 {
                return last4
            }
            else if self.number && self.number.length >= 4 {
                return self.number.substringFromIndex((self.number.length - 4))
            }
            else {
                return nil
            }
    
        }
    }

    var type: String {
        get {
            if type != nil {
                return type
            }
            else if self.number {
                return self.self.cardBrandFromNumber(self.number)
            }
            else {
                return nil
            }
    
        }
    }

    var fingerprint: String
    var country: String
}
//
//  STPCard.m
//  Stripe
//
//  Created by Saikat Chakrabarti on 11/2/12.
//
//