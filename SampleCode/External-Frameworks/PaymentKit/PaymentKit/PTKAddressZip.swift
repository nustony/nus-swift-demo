//
//  PTKZip.h
//  PTKPayment Example
//
//  Created by Alex MacCaw on 2/1/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//
import Foundation
class PTKAddressZip: PTKComponent {
    var zip: String

    var string: String {
        get {
            return zip
        }
    }


    class func addressZipWithString(string: String) -> Self {
        return self(string: string)
    }

    convenience override init(string: String) {
        super.init()
        self.zip = string.copy()
    }

    func isValid() -> Bool {
        var stripped: String = zip.stringByReplacingOccurrencesOfString("\\s", withString: "", options: NSRegularExpressionSearch, range: NSMakeRange(0, zip.length))
        return stripped.length > 2
    }

    func isPartiallyValid() -> Bool {
        return zip.length < 10
    }
}
//
//  PTKZip.m
//  PTKPayment Example
//
//  Created by Alex MacCaw on 2/1/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//