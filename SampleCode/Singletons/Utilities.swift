//
//  Utilities.h
//  Sample Code
//
//  Created by NUS Technology on 8/23/14.
//  Copyright (c) 2014 Sample Code, LLC. All rights reserved.
//
import Foundation
class Utilities: NSObject {
    class func sharedInstance() -> AnyObject {
        var sharedInstance: Utilities? = nil
            var oncePredicate: dispatch_once_t
        dispatch_once(oncePredicate, {() -> Void in
            self.sharedInstance = Utilities()
        })
        return sharedInstance!
    }

    func isValidEmail(email: String) -> Bool {
        var stricterFilter: Bool = true
        var stricterFilterString: String = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        var laxString: String = ".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*"
        var emailRegex: String = stricterFilter ? stricterFilterString : laxString
        var emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluateWithObject(email)
    }

    func showOKMessage(text: String, withTitle title: String) {
        UIAlertView(title: title, message: text, delegate: self, cancelButtonTitle: LOCALIZATION("ok"), otherButtonTitles: "").show()
    }

    // Check email is valid
    // Show an alert message
}
//
//  Utilities.m
//  Sample Code
//
//  Created by NUS Technology on 8/23/14.
//  Copyright (c) 2014 Sample Code, LLC. All rights reserved.
//