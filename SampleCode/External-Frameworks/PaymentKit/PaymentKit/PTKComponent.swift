//
//  PTKComponent.h
//  Stripe
//
//  Created by Phil Cohen on 12/18/13.
//
//
import Foundation
// Abstract class; represents a component of a credit card.
class PTKComponent: NSObject {
    convenience override init(string: String) {
        return (super.init())
    }

    func string() -> String {
        NSException.exceptionWithName(NSInternalInconsistencyException, reason: "You must override \(NSStringFromSelector(cmd)) in a subclass", userInfo: nil)
    }

    func formattedString() -> String {
        return self.string()
    }

    func isValid() -> Bool {
        NSException.exceptionWithName(NSInternalInconsistencyException, reason: "You must override \(NSStringFromSelector(cmd)) in a subclass", userInfo: nil)
    }
    // Whether the value is valid so far, even if incomplete (useful for as-you-type validation).

    func isPartiallyValid() -> Bool {
        NSException.exceptionWithName(NSInternalInconsistencyException, reason: "You must override \(NSStringFromSelector(cmd)) in a subclass", userInfo: nil)
    }
    // The formatted value with trailing spaces inserted as needed (such as after groups in the credit card number).

    func formattedStringWithTrail() -> String {
        return self.string()
    }
}
//
//  PTKComponent.m
//  Stripe
//
//  Created by Phil Cohen on 12/18/13.
//
//