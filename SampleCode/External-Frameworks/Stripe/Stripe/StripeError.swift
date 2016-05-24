//
//  StripeError.h
//  Stripe
//
//  Created by Saikat Chakrabarti on 11/4/12.
//
//
import Foundation
// All Stripe iOS errors will be under this domain.
let StripeDomain: FOUNDATION_EXPORT NSString

enum STPErrorCode : Int {
    case STPConnectionError = 40
    // Trouble connecting to Stripe.
    case STPInvalidRequestError = 50
    // Your request had invalid parameters.
    case STPAPIError = 60
    // General-purpose API error (should be rare).
    case STPCardError = 70
}

// A developer-friendly error message that explains what went wrong. You probably
// shouldn't show this to your users, but might want to use it yourself.
let STPErrorMessageKey: FOUNDATION_EXPORT NSString

// What went wrong with your STPCard (e.g., STPInvalidCVC. See below for full list).
let STPCardErrorCodeKey: FOUNDATION_EXPORT NSString

// Which parameter on the STPCard had an error (e.g., "cvc"). Useful for marking up the
// right UI element.
let STPErrorParameterKey: FOUNDATION_EXPORT NSString

// (Usually determined locally:)
let STPInvalidNumber: FOUNDATION_EXPORT NSString

let STPInvalidExpMonth: FOUNDATION_EXPORT NSString

let STPInvalidExpYear: FOUNDATION_EXPORT NSString

let STPInvalidCVC: FOUNDATION_EXPORT NSString

// (Usually sent from the server:)
let STPIncorrectNumber: FOUNDATION_EXPORT NSString

let STPExpiredCard: FOUNDATION_EXPORT NSString

let STPCardDeclined: FOUNDATION_EXPORT NSString

let STPProcessingError: FOUNDATION_EXPORT NSString

let STPIncorrectCVC: FOUNDATION_EXPORT NSString

let STPCardErrorInvalidNumberUserMessage = NSLocalizedString("Your card's number is invalid", "Error when the card number is not valid")
let STPCardErrorInvalidCVCUserMessage = NSLocalizedString("Your card's security code is invalid", "Error when the card's CVC is not valid")
let STPCardErrorInvalidExpMonthUserMessage = \
func () {
    ("Your card's expiration month is invalid", "Error when the card's expiration month is not valid")
}

let STPCardErrorInvalidExpYearUserMessage = \
func () {
    ("Your card's expiration year is invalid", "Error when the card's expiration year is not valid")
}

let STPCardErrorExpiredCardUserMessage = NSLocalizedString("Your card has expired", "Error when the card has already expired")
let STPCardErrorDeclinedUserMessage = NSLocalizedString("Your card was declined", "Error when the card was declined by the credit card networks")
let STPUnexpectedError = \
func () {
    ("There was an unexpected error -- try again in a few seconds", "Unexpected error, such as a 500 from Stripe or a JSON parse error")
}

let STPCardErrorProcessingErrorUserMessage = \
func () {
    ("There was an error processing your card -- try again in a few seconds", "Error when there is a problem processing the credit card")
}

//
//  StripeError.m
//  Stripe
//
//  Created by Saikat Chakrabarti on 11/4/12.
//
//

let StripeDomain: String = "com.stripe.lib"

let STPCardErrorCodeKey: String = "com.stripe.lib:CardErrorCodeKey"

let STPErrorMessageKey: String = "com.stripe.lib:ErrorMessageKey"

let STPErrorParameterKey: String = "com.stripe.lib:ErrorParameterKey"

let STPInvalidNumber: String = "com.stripe.lib:InvalidNumber"

let STPInvalidExpMonth: String = "com.stripe.lib:InvalidExpiryMonth"

let STPInvalidExpYear: String = "com.stripe.lib:InvalidExpiryYear"

let STPInvalidCVC: String = "com.stripe.lib:InvalidCVC"

let STPIncorrectNumber: String = "com.stripe.lib:IncorrectNumber"

let STPExpiredCard: String = "com.stripe.lib:ExpiredCard"

let STPCardDeclined: String = "com.stripe.lib:CardDeclined"

let STPProcessingError: String = "com.stripe.lib:ProcessingError"

let STPIncorrectCVC: String = "com.stripe.lib:IncorrectCVC"