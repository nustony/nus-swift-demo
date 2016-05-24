//
//  PTKUSAddressZip.h
//  PaymentKit Example
//
//  Created by Alex MacCaw on 2/17/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//
import Foundation
class PTKUSAddressZip: PTKAddressZip {

    convenience override init(string: String) {
        super.init()
        // Strip non-digits
            self.zip = string.stringByReplacingOccurrencesOfString("\\D", withString: "", options: NSRegularExpressionSearch, range: NSMakeRange(0, string.length))
    }

    func isValid() -> Bool {
        return zip.length == 5
    }

    func isPartiallyValid() -> Bool {
        return zip.length <= 5
    }
}
//
//  PTKUSAddressZip.m
//  PaymentKit Example
//
//  Created by Alex MacCaw on 2/17/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//