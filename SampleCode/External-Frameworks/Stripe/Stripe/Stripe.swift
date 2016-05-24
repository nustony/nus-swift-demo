//
//  Stripe.h
//  Stripe
//
//  Created by Saikat Chakrabarti on 10/30/12.
//  Copyright (c) 2012 Stripe. All rights reserved.
//
import Foundation
let kStripeiOSVersion: FOUNDATION_EXPORT NSString

// Version of this library.
typealias STPCompletionBlock = (token: STPToken, error: NSError) -> Void
// Stripe is a static class used to create and retrieve tokens.
class Stripe: NSObject {
    /*
     If you set a default publishable key, it will be used in any of the methods
     below that do not accept a publishable key parameter
     */
    class func defaultPublishableKey() -> String {
        return defaultKey
    }

    class func setDefaultPublishableKey(publishableKey: String) {
        self.validateKey(publishableKey)
        defaultKey = publishableKey
    }

    class func createTokenWithCard(card: STPCard, completion handler: STPCompletionBlock) {
        self.createTokenWithCard(card, publishableKey: self.defaultPublishableKey(), completion: handler)
    }

    class func createTokenWithCard(card: STPCard, publishableKey: String, completion handler: STPCompletionBlock) {
        self.createTokenWithCard(card, publishableKey: publishableKey, operationQueue: NSOperationQueue.mainQueue(), completion: handler)
    }

    class func createTokenWithCard(card: STPCard, operationQueue queue: NSOperationQueue, completion handler: STPCompletionBlock) {
        self.createTokenWithCard(card, publishableKey: self.defaultPublishableKey(), operationQueue: queue, completion: handler)
    }

    class func createTokenWithCard(card: STPCard, publishableKey: String, operationQueue queue: NSOperationQueue, completion handler: STPCompletionBlock) {
        if card == nil {
            NSException.raise("RequiredParameter", format: "'card' is required to create a token")
        }
        if handler == nil {
            NSException.raise("RequiredParameter", format: "'handler' is required to use the token that is created")
        }
        self.validateKey(publishableKey)
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: self.apiURL)
        request.HTTPMethod = "POST"
        request.HTTPBody = card.formEncode()
        request.setValue(self.JSONStringForObject(self.stripeUserAgentDetails()), forHTTPHeaderField: "X-Stripe-User-Agent")
        request.setValue("Bearer ".stringByAppendingString(publishableKey), forHTTPHeaderField: "Authorization")
        STPAPIConnection(request: request).runOnOperationQueue(queue, completion: {(response: NSURLResponse, body: NSData, requestError: NSError) -> Void in
            self.handleTokenResponse(response, body: body, error: requestError, completion: handler)
        })
    }

    class func createTokenWithBankAccount(bankAccount: STPBankAccount, completion handler: STPCompletionBlock) {
        self.createTokenWithBankAccount(bankAccount, publishableKey: self.defaultPublishableKey(), completion: handler)
    }

    class func createTokenWithBankAccount(bankAccount: STPBankAccount, publishableKey: String, completion handler: STPCompletionBlock) {
        self.createTokenWithBankAccount(bankAccount, publishableKey: publishableKey, operationQueue: NSOperationQueue.mainQueue(), completion: handler)
    }

    class func createTokenWithBankAccount(bankAccount: STPBankAccount, operationQueue queue: NSOperationQueue, completion handler: STPCompletionBlock) {
        self.createTokenWithBankAccount(bankAccount, publishableKey: self.defaultPublishableKey(), operationQueue: queue, completion: handler)
    }

    class func createTokenWithBankAccount(bankAccount: STPBankAccount, publishableKey: String, operationQueue queue: NSOperationQueue, completion handler: STPCompletionBlock) {
        if bankAccount == nil {
            NSException.raise("RequiredParameter", format: "'bankAccount' is required to create a token")
        }
        if handler == nil {
            NSException.raise("RequiredParameter", format: "'handler' is required to use the token that is created")
        }
        self.validateKey(publishableKey)
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: self.apiURL)
        request.HTTPMethod = "POST"
        request.HTTPBody = bankAccount.formEncode()
        request.setValue(self.JSONStringForObject(self.stripeUserAgentDetails()), forHTTPHeaderField: "X-Stripe-User-Agent")
        request.setValue("Bearer ".stringByAppendingString(publishableKey), forHTTPHeaderField: "Authorization")
        STPAPIConnection(request: request).runOnOperationQueue(queue, completion: {(response: NSURLResponse, body: NSData, requestError: NSError) -> Void in
            self.handleTokenResponse(response, body: body, error: requestError, completion: handler)
        })
    }

    class func stripeUserAgentDetails() -> [NSObject : AnyObject] {
        var details: [NSObject : AnyObject] = ["lang": "objective-c", "bindings_version": kStripeiOSVersion].mutableCopy()
        var version: String = UIDevice.currentDevice().systemVersion
        if version != "" {
            details["os_version"] = version
        }
            var systemInfo: structutsname
        uname(systemInfo)
        var deviceType: String = String.stringWithCString(systemInfo.machine, encoding: NSUTF8StringEncoding)
        if deviceType != "" {
            details["type"] = deviceType
        }
        var model: String = UIDevice.currentDevice().localizedModel
        if model != "" {
            details["model"] = model
        }
        var vendorIdentifier: String = UIDevice.currentDevice().identifierForVendor.UUIDString()
        if vendorIdentifier != "" {
            details["vendor_identifier"] = vendorIdentifier
        }
        return details.copy()
    }

    class func apiURL() -> NSURL {
        var url: NSURL = NSURL(string: "https://\(apiURLBase)")!.URLByAppendingPathComponent(apiVersion).URLByAppendingPathComponent(tokenEndpoint)
        return url
    }

    class func handleTokenResponse(response: NSURLResponse, body: NSData, error requestError: NSError, completion handler: STPCompletionBlock) {
        if requestError {
                // If this is an error that Stripe returned, let's handle it as a StripeDomain error
            var jsonDictionary: [NSObject : AnyObject]? = nil
            if body && (jsonDictionary = self.dictionaryFromJSONData(body, error: nil)) && jsonDictionary!["error"] != nil {
                handler(nil, self.errorFromStripeResponse(jsonDictionary!))
            }
            else {
                handler(nil, requestError)
            }
        }
        else {
            var parseError: NSError
            var jsonDictionary: [NSObject : AnyObject] = self.dictionaryFromJSONData(body, error: parseError)
            if jsonDictionary == nil {
                handler(nil, parseError)
            }
            else if (response as! NSHTTPURLResponse).statusCode() == 200 {
                handler(STPToken(attributeDictionary: jsonDictionary), nil)
            }
            else {
                handler(nil, self.errorFromStripeResponse(jsonDictionary))
            }
        }
    }

    var defaultKey: String
    let apiURLBase: String = "api.stripe.com"
    let apiVersion: String = "v1"
    let tokenEndpoint: String = "tokens"

    class func alloc() -> AnyObject {
        NSException.raise("CannotInstantiateStaticClass", format: "'Stripe' is a static class and cannot be instantiated.")
        return nil
    }

    class func dictionaryFromJSONData(data: NSData, error outError: NSError) -> [NSObject : AnyObject] {
        var jsonDictionary: [NSObject : AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options: 0, error: nil)
        if jsonDictionary == nil {
            var userInfo: [NSObject : AnyObject] = [NSLocalizedDescriptionKey: STPUnexpectedError, STPErrorMessageKey: "The response from Stripe failed to get parsed into valid JSON."]
            if outError {
                outError = NSError(domain: StripeDomain, code: STPAPIError, userInfo: userInfo)
            }
            return nil
        }
        return jsonDictionary
    }

    class func validateKey(publishableKey: String) {
        if !publishableKey || (publishableKey == "") {
            NSException.raise("InvalidPublishableKey", format: "You must use a valid publishable key to create a token. For more info, see https://stripe.com/docs/stripe.js")
        }
        if publishableKey.hasPrefix("sk_") {
            NSException.raise("InvalidPublishableKey", format: "You are using a secret key to create a token, instead of the publishable one. For more info, see https://stripe.com/docs/stripe.js")
        }
    }

    class func cardErrorCodeMap() -> [NSObject : AnyObject] {
        var errorDictionary: AnyObject? = nil
        if !errorDictionary {
            errorDictionary = ["incorrect_number": ["code": STPIncorrectNumber, "message": STPCardErrorInvalidNumberUserMessage], "invalid_number": ["code": STPInvalidNumber, "message": STPCardErrorInvalidNumberUserMessage], "invalid_expiry_month": ["code": STPInvalidExpMonth, "message": STPCardErrorInvalidExpMonthUserMessage], "invalid_expiry_year": ["code": STPInvalidExpYear, "message": STPCardErrorInvalidExpYearUserMessage], "invalid_cvc": ["code": STPInvalidCVC, "message": STPCardErrorInvalidCVCUserMessage], "expired_card": ["code": STPExpiredCard, "message": STPCardErrorExpiredCardUserMessage], "incorrect_cvc": ["code": STPIncorrectCVC, "message": STPCardErrorInvalidCVCUserMessage], "card_declined": ["code": STPCardDeclined, "message": STPCardErrorDeclinedUserMessage], "processing_error": ["code": STPProcessingError, "message": STPCardErrorProcessingErrorUserMessage]]
        }
        return errorDictionary!
    }

    class func errorFromStripeResponse(jsonDictionary: [NSObject : AnyObject]) -> NSError {
        var errorDictionary: [NSObject : AnyObject] = jsonDictionary["error"]
        var type: String = errorDictionary["type"]
        var devMessage: String = errorDictionary["message"]
        var parameter: String = errorDictionary["param"]
        var code: Int = 0
        // There should always be a message and type for the error
        if devMessage == nil || type == nil {
            var userInfo: [NSObject : AnyObject] = [NSLocalizedDescriptionKey: STPUnexpectedError, STPErrorMessageKey: "Could not interpret the error response that was returned from Stripe."]
            return NSError(domain: StripeDomain, code: STPAPIError, userInfo: userInfo)
        }
        var userInfo: [NSObject : AnyObject] = NSMutableDictionary()
        userInfo[STPErrorMessageKey] = devMessage
        if parameter != "" {
            userInfo[STPErrorParameterKey] = STPUtils.stringByReplacingSnakeCaseWithCamelCase(parameter)
        }
        if (type == "api_error") {
            code = STPAPIError
            userInfo[NSLocalizedDescriptionKey] = STPUnexpectedError
        }
        else if (type == "invalid_request_error") {
            code = STPInvalidRequestError
            userInfo[NSLocalizedDescriptionKey] = devMessage
        }
        else if (type == "card_error") {
            code = STPCardError
            var codeMapEntry: [NSObject : AnyObject] = Stripe.cardErrorCodeMap()[errorDictionary["code"]]
            if codeMapEntry != nil {
                userInfo[STPCardErrorCodeKey] = codeMapEntry["code"]
                userInfo[NSLocalizedDescriptionKey] = codeMapEntry["message"]
            }
            else {
                userInfo[STPCardErrorCodeKey] = errorDictionary["code"]
                userInfo[NSLocalizedDescriptionKey] = devMessage
            }
        }

        return NSError(domain: StripeDomain, code: code, userInfo: userInfo)
    }

    class func JSONStringForObject(object: AnyObject) -> String {
        return String(data: NSJSONSerialization.dataWithJSONObject(object, options: 0, error: nil), encoding: NSUTF8StringEncoding)
    }
}
//
//  Stripe.m
//  Stripe
//
//  Created by Saikat Chakrabarti on 10/30/12.
//  Copyright (c) 2012 Stripe. All rights reserved.
//
import UIKit
import sys
let kStripeiOSVersion: String = "2.2.2"