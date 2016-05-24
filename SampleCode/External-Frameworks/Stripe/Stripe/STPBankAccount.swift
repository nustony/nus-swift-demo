//
//  STPBankAccount.h
//  Stripe
//
//  Created by Charles Scalesse on 10/1/14.
//
//
import Foundation
class STPBankAccount: NSObject, STPFormEncodeProtocol {
    var accountNumber: String
    var routingNumber: String
    var country: String
    var object: String {
        get {
            return self.object
        }
    }

    var bankAccountId: String {
        get {
            return self.bankAccountId
        }
    }

    var last4: String {
        get {
            if last4 {
                return last4
            }
            else if self.accountNumber && self.accountNumber.length >= 4 {
                return self.accountNumber.substringFromIndex((self.accountNumber.length - 4))
            }
            else {
                return nil
            }
    
        }
    }

    var bankName: String {
        get {
            return self.bankName
        }
    }

    var fingerprint: String {
        get {
            return self.fingerprint
        }
    }

    var currency: String {
        get {
            return self.currency
        }
    }

    var validated: Bool {
        get {
            return self.validated
        }
    }

    var disabled: Bool {
        get {
            return self.disabled
        }
    }


    convenience override init(attributeDictionary: [NSObject : AnyObject]) {
        self = self()
                // sanitize NSNull
            var dictionary: [NSObject : AnyObject] = NSMutableDictionary()
            attributeDictionary.enumerateKeysAndObjectsUsingBlock({(key: AnyObject, obj: AnyObject, stop: Bool) -> Void in
                if obj != NSNull() {
                    dictionary[key] = obj
                }
            })
            self.object = dictionary["object"]
            self.bankAccountId = dictionary["id"]
            self.last4 = dictionary["last4"]
            self.bankName = dictionary["bank_name"]
            self.country = dictionary["country"]
            self.fingerprint = dictionary["fingerprint"]
            self.currency = dictionary["currency"]
            self.validated = CBool(dictionary["validated"])!
            self.disabled = CBool(dictionary["disabled"])!
    }

    func isEqualToBankAccount(bankAccount: STPBankAccount) -> Bool {
        if self == bankAccount {
            return true
        }
        if !bankAccount || !(bankAccount is self.self) {
            return false
        }
        return (self.accountNumber ?? "" == bankAccount.accountNumber ?? "") && (self.routingNumber ?? "" == bankAccount.routingNumber ?? "") && (self.country ?? "" == bankAccount.country ?? "") && (self.last4 ?? "" == bankAccount.last4 ?? "") && (self.bankName ?? "" == bankAccount.bankName ?? "") && (self.currency ?? "" == bankAccount.currency ?? "")
    }

    convenience override init() {
        super.init()
                self.object = "bank_account"
    }

    func formEncode() -> NSData {
        var params: [NSObject : AnyObject] = NSMutableDictionary()
        var parts: [AnyObject] = NSMutableArray()
        if accountNumber {
            params["account_number"] = accountNumber
        }
        if routingNumber {
            params["routing_number"] = routingNumber
        }
        if country != "" {
            params["country"] = country
        }
        params.enumerateKeysAndObjectsUsingBlock({(key: AnyObject, val: AnyObject, stop: Bool) -> Void in
            if val != NSNull() {
                parts.append("bank_account[\(key)]=\(STPUtils.stringByURLEncoding(val))")
            }
        })
        return parts.componentsJoinedByString("&").dataUsingEncoding(NSUTF8StringEncoding)
    }

    func isEqual(bankAccount: STPBankAccount) -> Bool {
        return self.isEqualToBankAccount(bankAccount)
    }

    var object: String
    var bankAccountId: String
    var last4: String {
        get {
            if last4 {
                return last4
            }
            else if self.accountNumber && self.accountNumber.length >= 4 {
                return self.accountNumber.substringFromIndex((self.accountNumber.length - 4))
            }
            else {
                return nil
            }
    
        }
    }

    var bankName: String
    var fingerprint: String
    var currency: String
    var validated: Bool
    var disabled: Bool
}
//
//  STPBankAccount.m
//  Stripe
//
//  Created by Charles Scalesse on 10/1/14.
//
//