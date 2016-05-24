//
//  STPUtils.h
//  Stripe
//
//  Created by Ray Morgan on 7/11/14.
//
//
import Foundation
class STPUtils: NSObject {
    class func stringByReplacingSnakeCaseWithCamelCase(input: String) -> String {
        var parts: [AnyObject] = input.componentsSeparatedByString("_")
        var camelCaseParam: NSMutableString = NSMutableString.string()
        parts.enumerateObjectsUsingBlock({(part: String, idx: Int, stop: Bool) -> Void in
            camelCaseParam.appendString((idx == 0 ? part : part.capitalizedString))
            if idx > 0 {
                camelCaseParam.appendString(part.capitalizedString)
            }
            else {
                camelCaseParam.appendString(part)
            }
        })
        return camelCaseParam.copy()
    }

    class func stringByURLEncoding(string: String) -> String {
        var output: NSMutableString = NSMutableString.string()
        let source: UInt8 = UInt8(string.UTF8String())
        var sourceLen: Int = strlen(Character(source))
        for var i = 0; i < sourceLen; ++i {
            let thisChar: UInt8 = source[i]
            if thisChar == " " {
                output.appendString("+")
            }
            else if thisChar == "." || thisChar == "-" || thisChar == "_" || thisChar == "~" || (thisChar >= "a" && thisChar <= "z") || (thisChar >= "A" && thisChar <= "Z") || (thisChar >= "0" && thisChar <= "9") {
                output.appendFormat("%c", thisChar)
            }
            else {
                output.appendFormat("%%%02X", thisChar)
            }
        }
        return output
    }

    /* This code is adapted from the code by David DeLong in this StackOverflow post:
     http://stackoverflow.com/questions/3423545/objective-c-iphone-percent-encode-a-string .  It is protected under the terms of a Creative Commons
     license: http://creativecommons.org/licenses/by-sa/3.0/
     */
}
//
//  STPUtils.m
//  Stripe
//
//  Created by Ray Morgan on 7/11/14.
//
//