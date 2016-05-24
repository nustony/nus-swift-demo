//
//  PTKPaymentField.h
//  PTKPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//
import UIKit
protocol PTKViewDelegate: NSObject {
    func paymentView(paymentView: PTKView, withCard card: PTKCard, isValid valid: Bool)
}
class PTKView: UIView {
    func isValid() -> Bool {
        return self.cardNumber.isValid() && self.cardExpiry.isValid() && self.cardCVC.isValidWithType(self.cardNumber.cardType)
    }
    var opaqueOverGradientView: UIView {
        get {
            return self.opaqueOverGradientView
        }
    }

    var cardNumber: PTKCardNumber {
        get {
            return PTKCardNumber.cardNumberWithString(self.cardNumberField.text!)
        }
    }

    var cardExpiry: PTKCardExpiry {
        get {
            return PTKCardExpiry.cardExpiryWithString(self.cardExpiryField.text!)
        }
    }

    var cardCVC: PTKCardCVC {
        get {
            return PTKCardCVC.cardCVCWithString(self.cardCVCField.text!)
        }
    }

    var addressZip: PTKAddressZip {
        get {
            return self.addressZip
        }
    }

    @IBOutlet var innerView: UIView!
    @IBOutlet var clipView: UIView!
    @IBOutlet var cardNumberField: PTKTextField!
    @IBOutlet var cardExpiryField: PTKTextField!
    @IBOutlet var cardCVCField: PTKTextField!
    @IBOutlet var placeholderView: UIImageView!
    weak var delegate: PTKViewDelegate
    var card: PTKCard {
        get {
            var card: PTKCard = PTKCard()
            card.number = self.cardNumber.string()
            card.cvc = self.cardCVC.string()
            card.expMonth = self.cardExpiry.month()
            card.expYear = self.cardExpiry.year()
            return card
        }
    }

    convenience override init(frame: CGRect) {
        super.init(frame: frame)
                self.setup()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }

    func setup() {
        self.isInitialState = true
        self.isValidState = false
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, super.frame.size.width,         /*290*/
, 46)
        self.backgroundColor = UIColor.clearColor()
        //    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        //    backgroundImageView.image = [[UIImage imageNamed:@"textfield"]
        //            resizableImageWithCapInsets:UIEdgeInsetsMake(0, 8, 0, 8)];
        //    [self addSubview:backgroundImageView];
        self.innerView = UIView(frame: CGRectMake(40, 12, self.frame.size.width - 40, 20))
        self.innerView.clipsToBounds = true
        self.setupPlaceholderView()
        self.setupCardNumberField()
        self.setupCardExpiryField()
        self.setupCardCVCField()
        self.innerView.addSubview(self.cardNumberField)
        var gradientImageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, 12, 34))
        gradientImageView.image = UIImage(named: "gradient")
        self.innerView.addSubview(gradientImageView)
        self.opaqueOverGradientView = UIView(frame: CGRectMake(0, 0, 9, 34))
        self.opaqueOverGradientView.backgroundColor = UIColor(red: 0.9686, green: 0.9686, blue: 0.9686, alpha: 1.0000)
        self.opaqueOverGradientView.alpha = 0.0
        self.innerView.addSubview(self.opaqueOverGradientView)
        self.addSubview(self.innerView)
        self.addSubview(self.placeholderView)
        self.stateCardNumber()
    }

    func setupPlaceholderView() {
        self.placeholderView = UIImageView(frame: CGRectMake(12, 13, 32, 20))
        self.placeholderView.backgroundColor = UIColor.clearColor()
        self.placeholderView.image = UIImage(named: "placeholder")
        var clip: CALayer = CALayer.layer
        clip.frame = CGRectMake(32, 0, 4, 20)
        clip.backgroundColor = UIColor.clearColor().CGColor
        self.placeholderView.layer.addSublayer(clip)
    }

    func setupCardNumberField() {
        self.cardNumberField = PTKTextField(frame: CGRectMake(12, 0, 170, 20))
        self.cardNumberField.delegate = self
        self.cardNumberField.placeholder = self.self.localizedStringWithKey("placeholder.card_number", defaultValue: "1234 5678 9012 3456")
        self.cardNumberField.keyboardType = .NumberPad
        self.cardNumberField.textColor = DarkGreyColor
        self.cardNumberField.font = DefaultBoldFont
        self.cardNumberField.layer.masksToBounds = true
    }

    func setupCardExpiryField() {
        self.cardExpiryField = PTKTextField(frame: CGRectMake(kPTKViewCardExpiryFieldStartX, 0, 60, 20))
        self.cardExpiryField.delegate = self
        self.cardExpiryField.placeholder = self.self.localizedStringWithKey("placeholder.card_expiry", defaultValue: "MM/YY")
        self.cardExpiryField.keyboardType = .NumberPad
        self.cardExpiryField.textColor = DarkGreyColor
        self.cardExpiryField.font = DefaultBoldFont
        self.cardExpiryField.layer.masksToBounds = true
    }

    func setupCardCVCField() {
        self.cardCVCField = PTKTextField(frame: CGRectMake(kPTKViewCardCVCFieldStartX, 0, 55, 20))
        self.cardCVCField.delegate = self
        self.cardCVCField.placeholder = self.self.localizedStringWithKey("placeholder.card_cvc", defaultValue: "CVC")
        self.cardCVCField.keyboardType = .NumberPad
        self.cardCVCField.textColor = DarkGreyColor
        self.cardCVCField.font = DefaultBoldFont
        self.cardCVCField.layer.masksToBounds = true
    }
    // Checks both the old and new localization table (we switched in 3/14 to PaymentKit.strings).
    // Leave this in for a long while to preserve compatibility.

    class func localizedStringWithKey(key: String, defaultValue: String) -> String {
        var value: String = NSLocalizedStringFromTable(key, kPTKLocalizedStringsTableName, nil)
        if value && !(value == key) {
            // key == no value
            return value
        }
        else {
            value = NSLocalizedStringFromTable(key, kPTKOldLocalizedStringsTableName, nil)
            if value && !(value == key) {
                return value
            }
        }
        return defaultValue
    }

    func stateCardNumber() {
        if !isInitialState {
            // Animate left
            self.isInitialState = true
            UIView.animateWithDuration(0.05, delay: 0.0, options: .CurveEaseInOut, animations: {() -> Void in
                self.opaqueOverGradientView.alpha = 0.0
            }, completion: {(finished: Bool) -> Void in
            })
            UIView.animateWithDuration(0.400, delay: 0, options: ([.CurveEaseInOut, .AllowUserInteraction]), animations: {() -> Void in
                self.cardExpiryField.frame = CGRectMake(kPTKViewCardExpiryFieldStartX, self.cardExpiryField.frame.origin.y, self.cardExpiryField.frame.size.width, self.cardExpiryField.frame.size.height)
                self.cardCVCField.frame = CGRectMake(kPTKViewCardCVCFieldStartX, self.cardCVCField.frame.origin.y, self.cardCVCField.frame.size.width, self.cardCVCField.frame.size.height)
                self.cardNumberField.frame = CGRectMake(12, self.cardNumberField.frame.origin.y, self.cardNumberField.frame.size.width, self.cardNumberField.frame.size.height)
            }, completion: {(completed: Bool) -> Void in
                self.cardExpiryField.removeFromSuperview()
                self.cardCVCField.removeFromSuperview()
            })
        }
        //[self.cardNumberField becomeFirstResponder];
    }

    func stateMeta() {
        self.isInitialState = false
            var cardNumberSize: CGSize
            var lastGroupSize: CGSize
        if self.cardNumber.formattedString.respondsToSelector("sizeWithAttributes:") {
            var attributes: [NSObject : AnyObject] = [NSFontAttributeName: DefaultBoldFont]
            cardNumberSize = self.cardNumber.formattedString.sizeWithAttributes(attributes)
            lastGroupSize = self.cardNumber.lastGroup.sizeWithAttributes(attributes)
        }
        else {
            cardNumberSize = self.cardNumber.formattedString.sizeWithFont(DefaultBoldFont)
            lastGroupSize = self.cardNumber.lastGroup.sizeWithFont(DefaultBoldFont)
        }
        var attributes: [NSObject : AnyObject] = [NSFontAttributeName: DefaultBoldFont]
        cardNumberSize = self.cardNumber.formattedString.sizeWithAttributes(attributes)
        lastGroupSize = self.cardNumber.lastGroup.sizeWithAttributes(attributes)
        var frameX: CGFloat = self.cardNumberField.frame.origin.x - (cardNumberSize.width - lastGroupSize.width)
        UIView.animateWithDuration(0.05, delay: 0.35, options: .CurveEaseInOut, animations: {() -> Void in
            self.opaqueOverGradientView.alpha = 1.0
        }, completion: {(finished: Bool) -> Void in
        })
        UIView.animateWithDuration(0.400, delay: 0, options: .CurveEaseInOut, animations: {() -> Void in
            self.cardExpiryField.frame = CGRectMake(kPTKViewCardExpiryFieldEndX, self.cardExpiryField.frame.origin.y, self.cardExpiryField.frame.size.width, self.cardExpiryField.frame.size.height)
            self.cardCVCField.frame = CGRectMake(kPTKViewCardCVCFieldEndX, self.cardCVCField.frame.origin.y, self.cardCVCField.frame.size.width, self.cardCVCField.frame.size.height)
            self.cardNumberField.frame = CGRectMake(frameX, self.cardNumberField.frame.origin.y, self.cardNumberField.frame.size.width, self.cardNumberField.frame.size.height)
        }, completion: { _ in })
        self.addSubview(self.placeholderView)
        self.innerView.addSubview(self.cardExpiryField)
        self.innerView.addSubview(self.cardCVCField)
        self.cardExpiryField.becomeFirstResponder()
    }

    func stateCardCVC() {
        self.cardCVCField.becomeFirstResponder()
    }

    func setPlaceholderViewImage(image: UIImage) {
        if !self.placeholderView.image.isEqual(image) {
            var previousPlaceholderView: UIView = self.placeholderView
            UIView.animateWithDuration(kPTKViewPlaceholderViewAnimationDuration, delay: 0, options: .CurveEaseInOut, animations: {() -> Void in
                self.placeholderView.layer.opacity = 0.0
                self.placeholderView.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1.2)
            }, completion: {(finished: Bool) -> Void in
                previousPlaceholderView.removeFromSuperview()
            })
            self.placeholderView = nil
            self.setupPlaceholderView()
            self.placeholderView.image = image
            self.placeholderView.layer.opacity = 0.0
            self.placeholderView.layer.transform = CATransform3DMakeScale(0.8, 0.8, 0.8)
            self.insertSubview(self.placeholderView, belowSubview: previousPlaceholderView)
            UIView.animateWithDuration(kPTKViewPlaceholderViewAnimationDuration, delay: 0, options: .CurveEaseInOut, animations: {() -> Void in
                self.placeholderView.layer.opacity = 1.0
                self.placeholderView.layer.transform = CATransform3DIdentity
            }, completion: {(finished: Bool) -> Void in
            })
        }
    }

    func setPlaceholderToCVC() {
        var cardNumber: PTKCardNumber = PTKCardNumber.cardNumberWithString(self.cardNumberField.text!)
        var cardType: PTKCardType = cardNumber.cardType()
        if cardType == .Amex {
            self.placeholderViewImage = UIImage(named: "cvc-amex")
        }
        else {
            self.placeholderViewImage = UIImage(named: "cvc")
        }
    }

    func setPlaceholderToCardType() {
        var cardNumber: PTKCardNumber = PTKCardNumber.cardNumberWithString(self.cardNumberField.text!)
        var cardType: PTKCardType = cardNumber.cardType()
        var cardTypeName: String = "placeholder"
        switch cardType {
            case .Amex:
                cardTypeName = "amex"
            case .DinersClub:
                cardTypeName = "diners"
            case .Discover:
                cardTypeName = "discover"
            case .JCB:
                cardTypeName = "jcb"
            case .MasterCard:
                cardTypeName = "mastercard"
            case .Visa:
                cardTypeName = "visa"
            default:
                break
        }

        self.placeholderViewImage = UIImage(named: cardTypeName)
    }

    override func textFieldDidBeginEditing(textField: UITextField) {
        if textField.isEqual(self.cardCVCField) {
            self.setPlaceholderToCVC()
        }
        else {
            self.setPlaceholderToCardType()
        }
        if textField.isEqual(self.cardNumberField) && !isInitialState {
            self.stateCardNumber()
        }
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString: String) -> Bool {
        if textField.isEqual(self.cardNumberField) {
            return self.cardNumberFieldShouldChangeCharactersInRange(range, replacementString: replacementString)
        }
        if textField.isEqual(self.cardExpiryField) {
            return self.cardExpiryShouldChangeCharactersInRange(range, replacementString: replacementString)
        }
        if textField.isEqual(self.cardCVCField) {
            return self.cardCVCShouldChangeCharactersInRange(range, replacementString: replacementString)
        }
        return true
    }

    func pkTextFieldDidBackSpaceWhileTextIsEmpty(textField: PTKTextField) {
        if textField == self.cardCVCField {
            self.cardExpiryField.becomeFirstResponder()
        }
        else if textField == self.cardExpiryField {
            self.stateCardNumber()
        }

    }

    func cardNumberFieldShouldChangeCharactersInRange(range: NSRange, replacementString: String) -> Bool {
        var resultString: String = self.cardNumberField.text!.stringByReplacingCharactersInRange(range, withString: replacementString)
        resultString = PTKTextField.textByRemovingUselessSpacesFromString(resultString)
        var cardNumber: PTKCardNumber = PTKCardNumber.cardNumberWithString(resultString)
        if !cardNumber.isPartiallyValid() {
            return false
        }
        if replacementString.length > 0 {
            self.cardNumberField.text = cardNumber.formattedStringWithTrail()
        }
        else {
            self.cardNumberField.text = cardNumber.formattedString()
        }
        self.setPlaceholderToCardType()
        if cardNumber.isValid() {
            self.textFieldIsValid(self.cardNumberField)
            self.stateMeta()
        }
        else if cardNumber.isValidLength() && !cardNumber.isValidLuhn() {
            self.textFieldIsInvalid(self.cardNumberField, withErrors: true)
        }
        else if !cardNumber.isValidLength() {
            self.textFieldIsInvalid(self.cardNumberField, withErrors: false)
        }

        return false
    }

    func cardExpiryShouldChangeCharactersInRange(range: NSRange, replacementString: String) -> Bool {
        var resultString: String = self.cardExpiryField.text!.stringByReplacingCharactersInRange(range, withString: replacementString)
        resultString = PTKTextField.textByRemovingUselessSpacesFromString(resultString)
        var cardExpiry: PTKCardExpiry = PTKCardExpiry.cardExpiryWithString(resultString)
        if !cardExpiry.isPartiallyValid() {
            return false
        }
        // Only support shorthand year
        if cardExpiry.formattedString().length > 5 {
            return false
        }
        if replacementString.length > 0 {
            self.cardExpiryField.text = cardExpiry.formattedStringWithTrail()
        }
        else {
            self.cardExpiryField.text = cardExpiry.formattedString()
        }
        if cardExpiry.isValid() {
            self.textFieldIsValid(self.cardExpiryField)
            self.stateCardCVC()
        }
        else if cardExpiry.isValidLength() && !cardExpiry.isValidDate() {
            self.textFieldIsInvalid(self.cardExpiryField, withErrors: true)
        }
        else if !cardExpiry.isValidLength() {
            self.textFieldIsInvalid(self.cardExpiryField, withErrors: false)
        }

        return false
    }

    func cardCVCShouldChangeCharactersInRange(range: NSRange, replacementString: String) -> Bool {
        var resultString: String = self.cardCVCField.text!.stringByReplacingCharactersInRange(range, withString: replacementString)
        resultString = PTKTextField.textByRemovingUselessSpacesFromString(resultString)
        var cardCVC: PTKCardCVC = PTKCardCVC.cardCVCWithString(resultString)
        var cardType: PTKCardType = PTKCardNumber.cardNumberWithString(self.cardNumberField.text!).cardType()
        // Restrict length
        if !cardCVC.isPartiallyValidWithType(cardType) {
            return false
        }
        // Strip non-digits
        self.cardCVCField.text = cardCVC.string()
        if cardCVC.isValidWithType(cardType) {
            self.textFieldIsValid(self.cardCVCField)
        }
        else {
            self.textFieldIsInvalid(self.cardCVCField, withErrors: false)
        }
        return false
    }

    func checkValid() {
        if self.isValid() {
            self.isValidState = true
            if self.delegate.respondsToSelector("paymentView:withCard:isValid:") {
                self.delegate.paymentView(self, withCard: self.card, isValid: true)
            }
        }
        else if !self.isValid() && isValidState {
            self.isValidState = false
            if self.delegate.respondsToSelector("paymentView:withCard:isValid:") {
                self.delegate.paymentView(self, withCard: self.card, isValid: false)
            }
        }

    }

    func textFieldIsValid(textField: UITextField) {
        textField.textColor = DarkGreyColor
        self.checkValid()
    }

    func textFieldIsInvalid(textField: UITextField, withErrors errors: Bool) {
        if errors {
            textField.textColor = RedColor
        }
        else {
            textField.textColor = DarkGreyColor
        }
        self.checkValid()
    }

    func firstResponderField() -> UIResponder {
        var responders: [AnyObject] = [self.cardNumberField, self.cardExpiryField, self.cardCVCField]
        for responder: UIResponder in responders {
            if responder.isFirstResponder {
                return responder
            }
        }
        return nil
    }

    func firstInvalidField() -> PTKTextField {
        if !PTKCardNumber.cardNumberWithString(self.cardNumberField.text!).isValid() {
            return self.cardNumberField
        }
        else if !PTKCardExpiry.cardExpiryWithString(self.cardExpiryField.text!).isValid() {
            return self.cardExpiryField
        }
        else if !PTKCardCVC.cardCVCWithString(self.cardCVCField.text!).isValid() {
            return self.cardCVCField
        }

        return nil
    }

    func nextFirstResponder() -> PTKTextField {
        if self.firstInvalidField {
            return self.firstInvalidField
        }
        return self.cardCVCField
    }

    func isFirstResponder() -> Bool {
        return self.firstResponderField.isFirstResponder
    }

    func canBecomeFirstResponder() -> Bool {
        return self.nextFirstResponder.canBecomeFirstResponder
    }

    func becomeFirstResponder() -> Bool {
        return self.nextFirstResponder.becomeFirstResponder()
    }

    func canResignFirstResponder() -> Bool {
        return self.firstResponderField.canResignFirstResponder
    }

    func resignFirstResponder() -> Bool {
        return self.firstResponderField.resignFirstResponder()
    }
    var isInitialState: Bool
    var isValidState: Bool


    var firstResponderField: UIResponder {
        get {
            var responders: [AnyObject] = [self.cardNumberField, self.cardExpiryField, self.cardCVCField]
            for responder: UIResponder in responders {
                if responder.isFirstResponder {
                    return responder
                }
            }
            return nil
        }
    }

    var firstInvalidField: PTKTextField {
        get {
            if !PTKCardNumber.cardNumberWithString(self.cardNumberField.text!).isValid() {
                return self.cardNumberField
            }
            else if !PTKCardExpiry.cardExpiryWithString(self.cardExpiryField.text!).isValid() {
                return self.cardExpiryField
            }
            else if !PTKCardCVC.cardCVCWithString(self.cardCVCField.text!).isValid() {
                return self.cardCVCField
            }
    
            return nil
        }
    }

    var nextFirstResponder: PTKTextField {
        get {
            if self.firstInvalidField {
                return self.firstInvalidField
            }
            return self.cardCVCField
        }
    }


    func setup() {
    }

    func setupPlaceholderView() {
    }

    func setupCardNumberField() {
    }

    func setupCardExpiryField() {
    }

    func setupCardCVCField() {
    }

    func pkTextFieldDidBackSpaceWhileTextIsEmpty(textField: PTKTextField) {
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString: String) -> Bool {
    }

    func cardNumberFieldShouldChangeCharactersInRange(range: NSRange, replacementString: String) -> Bool {
    }

    func cardExpiryShouldChangeCharactersInRange(range: NSRange, replacementString: String) -> Bool {
    }

    func cardCVCShouldChangeCharactersInRange(range: NSRange, replacementString: String) -> Bool {
    }
    var opaqueOverGradientView: UIView
    var cardNumber: PTKCardNumber {
        get {
            return PTKCardNumber.cardNumberWithString(self.cardNumberField.text!)
        }
    }

    var cardExpiry: PTKCardExpiry {
        get {
            return PTKCardExpiry.cardExpiryWithString(self.cardExpiryField.text!)
        }
    }

    var cardCVC: PTKCardCVC {
        get {
            return PTKCardCVC.cardCVCWithString(self.cardCVCField.text!)
        }
    }

    var addressZip: PTKAddressZip
}
//
//  PTKPaymentField.m
//  PTKPayment Example
//
//  Created by Alex MacCaw on 1/22/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//
//#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
let DarkGreyColor = RGB(0, 0, 0)
let RedColor = RGB(253, 0, 17)
let DefaultBoldFont = UIFont.boldSystemFontOfSize(17)
let kPTKViewPlaceholderViewAnimationDuration = 0.25
let kPTKViewCardExpiryFieldStartX = 84 + 200
let kPTKViewCardCVCFieldStartX = 177 + 200
let kPTKViewCardExpiryFieldEndX = 84
let kPTKViewCardCVCFieldEndX = 177
let kPTKLocalizedStringsTableName: String = "PaymentKit"

let kPTKOldLocalizedStringsTableName: String = "STPaymentLocalizable"