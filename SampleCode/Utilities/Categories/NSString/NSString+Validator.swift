//
//  NSString+Validator.h
//  NUS Technology
//
//  Created by NUS Technology on 6/20/14.
//
//
import Foundation
extension NSString {
    func validateEmail() -> Bool {
        var emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        var emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluateWithObject(self)
    }
}
//
//  NSString+Validator.m
//  NUS Technology
//
//  Created by NUS Technology on 6/20/14.
//
//