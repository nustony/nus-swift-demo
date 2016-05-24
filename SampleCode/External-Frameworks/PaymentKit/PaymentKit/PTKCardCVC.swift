//
//  PTKCardCVC.h
//  PTKPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//
import Foundation
class PTKCardCVC: PTKComponent {
    var string: String {
        get {
            return cvc
        }
    }


    class func cardCVCWithString(string: String) -> Self {
        return self(string: string)
    }

    func isValidWithType(type: PTKCardType) -> Bool {
        if type == PTKCardTypeAmex {
            return cvc.length == 4
        }
        else {
            return cvc.length == 3
        }
    }

    func isPartiallyValidWithType(type: PTKCardType) -> Bool {
        if type == PTKCardTypeAmex {
            return cvc.length <= 4
        }
        else {
            return cvc.length <= 3
        }
    }
    var cvc: String


    convenience override init(string: String) {
        super.init()
        // Strip non-digits
            if string != "" {
                self.cvc = string.stringByReplacingOccurrencesOfString("\\D", withString: "", options: NSRegularExpressionSearch, range: NSMakeRange(0, string.length))
            }
            else {
                self.cvc = String.string()
            }
    }

    func isValid() -> Bool {
        return cvc.length >= 3 && cvc.length <= 4
    }

    func isPartiallyValid() -> Bool {
        return cvc.length <= 4
    }
}
//
//  PTKCardCVC.m
//  PTKPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//