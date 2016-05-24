//
//  STPToken.h
//  Stripe
//
//  Created by Saikat Chakrabarti on 11/5/12.
//
//
import Foundation
/*
 STPTokens get created by calls to + [Stripe createTokenWithCard:], + [Stripe createTokenWithBankAccount:], and + [Stripe getTokenWithId:].  You should not
 construct these yourself.
 */
class STPToken: NSObject {
    var tokenId: String {
        get {
            return self.tokenId
        }
    }

    var object: String {
        get {
            return self.object
        }
    }

    var livemode: Bool {
        get {
            return self.livemode
        }
    }

    var card: STPCard {
        get {
            return self.card
        }
    }

    var bankAccount: STPBankAccount {
        get {
            return self.bankAccount
        }
    }

    var created: NSDate {
        get {
            return self.created
        }
    }

    var used: Bool {
        get {
            return self.used
        }
    }


    func postToURL(url: NSURL, withParams params: [NSObject : AnyObject], completion handler: () -> Void) {
        var body: NSMutableString = "stripeToken=\(self.tokenId)"
        params.enumerateKeysAndObjectsUsingBlock({(key: AnyObject, obj: AnyObject, stop: Bool) -> Void in
            body.appendFormat("&%@=%@", key, obj)
        })
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: handler)
    }
    /*
     This method should not be invoked in your code.  This is used by Stripe to
     create tokens using a Stripe API response
     */

    convenience override init(attributeDictionary: [NSObject : AnyObject]) {
        super.init()
                self.tokenId = attributeDictionary["id"]
            self.object = attributeDictionary["object"]
            self.livemode = CBool(attributeDictionary["livemode"])!
            self.created = NSDate(timeIntervalSince1970: CDouble(attributeDictionary["created"])!)
            self.used = CBool(attributeDictionary["used"])!
            var cardDictionary: [NSObject : AnyObject] = attributeDictionary["card"]
            if cardDictionary != nil {
                self.card = STPCard(attributeDictionary: cardDictionary)
            }
            var bankAccountDictionary: [NSObject : AnyObject] = attributeDictionary["bank_account"]
            if bankAccountDictionary != nil {
                self.bankAccount = STPBankAccount(attributeDictionary: bankAccountDictionary)
            }
    }

    func description() -> String {
        var token: String = self.tokenId ? self.tokenId : "Unknown token"
        var livemode: String = self.livemode ? "live mode" : "test mode"
        return "\(token) (\(livemode))"
    }

    func isEqual(object: AnyObject) -> Bool {
        return self.isEqualToToken(object)
    }

    func isEqualToToken(object: STPToken) -> Bool {
        if self == object {
            return true
        }
        if !object || !(object is self.self) {
            return false
        }
        if (self.card || object.card) && (!self.card.isEqualToCard(object.card)) {
            return false
        }
        if (self.bankAccount || object.bankAccount) && (!self.bankAccount.isEqualToBankAccount(object.bankAccount)) {
            return false
        }
        return self.livemode == object.livemode && self.used == object.used && (self.tokenId == object.tokenId) && self.created.isEqualToDate(object.created) && self.card.isEqualToCard(object.card) && (self.tokenId == object.tokenId) && self.created.isEqualToDate(object.created)
    }
}
//
//  STPToken.m
//  Stripe
//
//  Created by Saikat Chakrabarti on 11/5/12.
//
//