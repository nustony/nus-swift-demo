//
//  PTKCard.h
//  PTKPayment Example
//
//  Created by Alex MacCaw on 1/31/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//
import Foundation
class PTKCard: NSObject {
    var number: String
    var cvc: String
    var addressZip: String
    var expMonth: Int
    var expYear: Int
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

    var brand: String
}
//
//  PTKCard.m
//  PTKPayment Example
//
//  Created by Alex MacCaw on 1/31/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//