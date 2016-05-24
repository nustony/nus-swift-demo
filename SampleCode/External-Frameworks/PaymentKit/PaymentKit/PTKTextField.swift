//
//  PTKTextField.h
//  PaymentKit Example
//
//  Created by Michaël Villar on 3/20/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//
import UIKit
protocol PTKTextFieldDelegate: UITextFieldDelegate {
    func pkTextFieldDidBackSpaceWhileTextIsEmpty(textField: PTKTextField)
}
class PTKTextField: UITextField {
    class func textByRemovingUselessSpacesFromString(string: String) -> String {
        return string.stringByReplacingOccurrencesOfString(kPTKTextFieldSpaceChar, withString: "")
    }
    weak var delegate: PTKTextFieldDelegate

    convenience override init(frame: CGRect) {
        super.init(frame: frame)
                self.text = kPTKTextFieldSpaceChar
            self.addObserver(self, forKeyPath: "text", options: 0, context: nil)
    }

    func dealloc() {
        self.removeObserver(self, forKeyPath: "text")
    }

    func drawPlaceholderInRect(rect: CGRect) {
    }

    override func drawRect(rect: CGRect) {
        if self.text.length == 0 || (self.text! == kPTKTextFieldSpaceChar) {
            var placeholderRect: CGRect = self.bounds
            placeholderRect.origin.y += 0.5
            super.drawPlaceholderInRect(placeholderRect)
        }
        else {
            super.drawRect(rect)
        }
    }

    func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: ) {
        if (keyPath == "text") && object == self {
            if self.text.length == 0 {
                if self.delegate.respondsToSelector("pkTextFieldDidBackSpaceWhileTextIsEmpty:") {
                    self.delegate.performSelector("pkTextFieldDidBackSpaceWhileTextIsEmpty:", withObject: self)
                }
                self.text = kPTKTextFieldSpaceChar
            }
            self.setNeedsDisplay()
        }
    }
}
//
//  PTKTextField.m
//  PaymentKit Example
//
//  Created by Michaël Villar on 3/20/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

let kPTKTextFieldSpaceChar = "\u{200B}"