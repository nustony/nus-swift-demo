//
//  NSString(Trim).h
//  NUS Technology
//
//  Created by NUS Technology on 6/20/14.
//
//
import Foundation
extension NSString {
    func trimPhoneNumber() -> String {
        var retPhoneNumber: String = self
        var components: [AnyObject] = retPhoneNumber.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        retPhoneNumber = components.componentsJoinedByString("")
        retPhoneNumber = retPhoneNumber.stringByReplacingOccurrencesOfString("+", withString: "")
        retPhoneNumber = retPhoneNumber.stringByReplacingOccurrencesOfString(" ", withString: "")
        retPhoneNumber = retPhoneNumber.stringByReplacingOccurrencesOfString("(", withString: "")
        retPhoneNumber = retPhoneNumber.stringByReplacingOccurrencesOfString(")", withString: "")
        return retPhoneNumber
    }
}
//
//  NSString(Trim).m
//  NUS Technology
//
//  Created by NUS Technology on 6/20/14.
//
//