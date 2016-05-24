//
//  CreditCardView.h
//  SampleCode
//
//  Created by Thach Bui-Khac on 1/27/15.
//  Copyright (c) 2015 MyID. All rights reserved.
//
import UIKit
protocol KNCreditCardViewDelegate: NSObject {
    func paymentView(paymentView: CreditCardView, withCard card: PTKCard, isValid valid: Bool)
}
class CreditCardView: UIView, UITextFieldDelegate {
    @IBOutlet weak var cardNumberField: TextField!
    @IBOutlet weak var cardExpiryMonthField: TextField!
    @IBOutlet weak var cardExpiryYearField: TextField!
    @IBOutlet weak var cardCVCField: TextField!
    weak var delegate: protocol<NSObject, KNCreditCardViewDelegate>
    // MARK - private variables
    var vBorderView: UIView
    var isValidState: Bool
    var originMonth: String


    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupControls()
    }

    func setup() {
        self.isValidState = false
    }

    override func setupControls() {
        self.setup()
        //    [self.cardNumberField setup];
        //    [self.cardExpiryMonthField setup];
        //    [self.cardExpiryYearField setup];
        //    [self.cardCVCField setup];
        // set no border for first & last text field
        self.cardNumberField.setNoBorder()
        self.cardCVCField.setNoBorder()
        self.cardExpiryMonthField.setNoBorder()
        self.cardExpiryYearField.setNoBorder()
        // initialize border view
        if !vBorderView {
            vBorderView = UIView(frame: CGRectMake(CGRectGetMinX(self.cardExpiryMonthField.frame), CGRectGetMinY(self.cardExpiryMonthField.frame), CGRectGetWidth(self.cardNumberField.frame), CGRectGetHeight(self.cardExpiryMonthField.frame)))
            self.insertSubview(vBorderView, aboveSubview: 0)
            // set border
            vBorderView.layer.borderColor = UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 0.8).CGColor
            vBorderView.layer.borderWidth = 0.5
        }
        else {
            vBorderView.frame = CGRectMake(CGRectGetMinX(self.cardExpiryMonthField.frame), CGRectGetMinY(self.cardExpiryMonthField.frame), CGRectGetWidth(self.cardNumberField.frame), CGRectGetHeight(self.cardExpiryMonthField.frame))
        }
    }

    func setTitleTextWithColor(color: UIColor) {
        // set title for text field
        self.cardNumberField.addTitleForLeftView(LOCALIZATION("cardNumber"), andTextColor: color)
        self.cardExpiryMonthField.addTitleForLeftView(LOCALIZATION("expirationDate"), andTextColor: color)
        self.cardCVCField.addTitleForLeftView(LOCALIZATION("cvc"), andTextColor: color)
    }
    // MARK - Accessors

    func cardNumber() -> PTKCardNumber {
        return PTKCardNumber.cardNumberWithString(self.cardNumberField.text!)
    }

    func cardExpiry() -> PTKCardExpiry {
        var text: String = self.getDateFromMonth(self.cardExpiryMonthField.text!, andYear: self.cardExpiryYearField.text!)
        return PTKCardExpiry.cardExpiryWithString(text)
    }

    func cardCVC() -> PTKCardCVC {
        return PTKCardCVC.cardCVCWithString(self.cardCVCField.text!)
    }

    func card() -> PTKCard {
        var card: PTKCard = PTKCard()
        card.number = self.cardNumber.string()
        card.cvc = self.cardCVC.string()
        card.expMonth = self.cardExpiry.month()
        card.expYear = self.cardExpiry.year()
        card.brand = self.getCardTypeInString()
        return card
    }
    // MARK - Delegates

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.isEqual(self.cardNumberField) {
            return self.cardNumberFieldShouldChangeCharactersInRange(range, replacementString: string)
        }
        // Month expiry field
        if textField.isEqual(self.cardExpiryMonthField) {
            return self.cardExpiryMonthShouldChangeCharactersInRange(range, replacementString: string)
        }
        // Year expiry field
        if textField.isEqual(self.cardExpiryYearField) {
            return self.cardExpiryYearShouldChangeCharactersInRange(range, replacementString: string)
        }
        if textField.isEqual(self.cardCVCField) {
            return self.cardCVCShouldChangeCharactersInRange(range, replacementString: string)
        }
        return true
    }

    func cardNumberFieldShouldChangeCharactersInRange(range: NSRange, replacementString string: String) -> Bool {
        var resultString: String = self.cardNumberField.text!.stringByReplacingCharactersInRange(range, withString: string)
        resultString = PTKTextField.textByRemovingUselessSpacesFromString(resultString)
        var cardNumber: PTKCardNumber = PTKCardNumber.cardNumberWithString(resultString)
        if !cardNumber.isPartiallyValid() {
            return false
        }
        if string.length > 0 {
            self.cardNumberField.text = cardNumber.formattedStringWithTrail()
        }
        else {
            self.cardNumberField.text = cardNumber.formattedString()
        }
        if cardNumber.isValid() {
            self.textFieldIsValid(self.cardNumberField)
            self.stateCardExpiredMonth()
        }
        else if cardNumber.isValidLength() && !cardNumber.isValidLuhn() {
            self.textFieldIsInvalid(self.cardNumberField, withErrors: true)
        }
        else if !cardNumber.isValidLength() {
            self.textFieldIsInvalid(self.cardNumberField, withErrors: false)
        }

        return false
    }

    func cardExpiryMonthShouldChangeCharactersInRange(range: NSRange, replacementString string: String) -> Bool {
        var resultString: String = self.cardExpiryMonthField.text!.stringByReplacingCharactersInRange(range, withString: string)
        resultString = self.getDateFromMonth(resultString, andYear: self.cardExpiryYearField.text!)
        resultString = PTKTextField.textByRemovingUselessSpacesFromString(resultString)
        var cardExpiry: PTKCardExpiry = PTKCardExpiry.cardExpiryWithString(resultString)
        if !cardExpiry.isPartiallyValid() {
            return false
        }
        if cardExpiry.formattedString.length > 7 {
            return false
        }
        if string.length > 0 {
            self.cardExpiryMonthField.text = self.getMonthFromDateString(cardExpiry.formattedStringWithTrail)
        }
        else {
            self.cardExpiryMonthField.text = self.getMonthFromDateString(cardExpiry.formattedString)
        }
        if cardExpiry.isValid() {
            self.textFieldIsValid(self.cardExpiryMonthField)
        }
        else if cardExpiry.isValidLength() && !cardExpiry.isValidDate() {
            self.textFieldIsInvalid(self.cardExpiryMonthField, withErrors: true)
        }
        else if !cardExpiry.isValidLength() {
            self.textFieldIsInvalid(self.cardExpiryMonthField, withErrors: false)
        }

        if self.cardExpiryMonthField.text.length == 2 {
            self.stateCardExpiredYear()
        }
        return false
    }

    func cardExpiryYearShouldChangeCharactersInRange(range: NSRange, replacementString string: String) -> Bool {
        var newRange: NSRange = NSMakeRange(range.location + 3, range.length)
        var resultString: String = self.getMonthYearForYearField().stringByReplacingCharactersInRange(newRange, withString: string)
        resultString = PTKTextField.textByRemovingUselessSpacesFromString(resultString)
        var cardExpiry: PTKCardExpiry = PTKCardExpiry.cardExpiryWithString(resultString)
        if !cardExpiry.isPartiallyValid() {
            return false
        }
        if cardExpiry.formattedString.length > 7 {
            return false
        }
        if string.length > 0 {
            self.cardExpiryYearField.text = self.getYearFromDateString(cardExpiry.formattedStringWithTrail)
        }
        else {
            self.cardExpiryYearField.text = self.getYearFromDateString(cardExpiry.formattedString)
        }
        if cardExpiry.isValid {
            self.textFieldIsValid(self.cardExpiryYearField)
        }
        else if cardExpiry.isValidLength && !cardExpiry.isValidDate {
            self.textFieldIsInvalid(self.cardExpiryYearField, withErrors: true)
        }
        else if !cardExpiry.isValidLength {
            self.textFieldIsInvalid(self.cardExpiryYearField, withErrors: false)
        }

        if self.cardExpiryYearField.text.length == 4 {
            self.stateCardCVC()
        }
        return false
    }

    func cardCVCShouldChangeCharactersInRange(range: NSRange, replacementString string: String) -> Bool {
        var resultString: String = self.cardCVCField.text!.stringByReplacingCharactersInRange(range, withString: string)
        resultString = PTKTextField.textByRemovingUselessSpacesFromString(resultString)
        var cardCVC: PTKCardCVC = PTKCardCVC.cardCVCWithString(resultString)
        var cardType: PTKCardType = PTKCardNumber.cardNumberWithString(self.cardNumberField.text!).cardType
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

    func getDateFromMonth(month: String, andYear year: String) -> String {
        var text: String = month
        if text.length == 2 {
            text = "\(text)/\(year)"
        }
        return text
    }

    func getMonthYearForYearField() -> String {
        var text: String = self.cardExpiryMonthField.text!
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en-US")
        dateFormatter.dateFormat = "MM"
        var now: NSDate = NSDate()
        if text.length == 0 {
            text = dateFormatter.stringFromDate(now)
        }
        else if text.length == 1 {
            text = dateFormatter.stringFromDate(now)
        }

        if text.length == 2 {
            text = "\(text)/\(self.cardExpiryMonthField.text!)"
        }
        return text
    }

    func getMonthFromDateString(date: String) -> String {
        if date.length <= 2 {
            return date
        }
        else {
            return date.substringWithRange(NSMakeRange(0, 2))
        }
    }

    func getYearFromDateString(date: String) -> String {
        if date.length <= 3 {
            return ""
        }
        else {
            return date.substringWithRange(NSMakeRange(3, date.length))
        }
    }

    func stateCardExpiredMonth() {
        self.cardExpiryMonthField.becomeFirstResponder()
    }

    func stateCardExpiredYear() {
        self.cardExpiryYearField.becomeFirstResponder()
    }

    func stateCardCVC() {
        self.cardCVCField.becomeFirstResponder()
    }

    func textFieldIsValid(textField: UITextField) {
        self.checkValid()
    }

    func textFieldIsInvalid(textField: UITextField, withErrors errors: Bool) {
        self.checkValid()
    }

    func checkValid() {
        if self.isValid() {
            self.isValidState = true
            if self.delegate && self.delegate.respondsToSelector("paymentView:withCard:isValid:") {
                self.delegate.paymentView(self, withCard: self.card(), isValid: true)
            }
        }
        else if !self.isValid() && isValidState {
            self.isValidState = false
            if self.delegate && self.delegate.respondsToSelector("paymentView:withCard:isValid:") {
                self.delegate.paymentView(self, withCard: self.card(), isValid: false)
            }
        }

    }

    func isValid() -> Bool {
        return self.cardNumber().isValid && self.cardExpiry().isValid && self.cardCVC().isValidWithType(self.cardNumber().cardType)
    }

    func getCardTypeInString() -> String {
        var cardType: PTKCardType = self.cardNumber().cardType
        var cardTypeName: String = ""
        switch cardType {
            case .Amex:
                cardTypeName = "AmEx"
            case .DinersClub:
                cardTypeName = "Diners"
            case .Discover:
                cardTypeName = "Discover"
            case .JCB:
                cardTypeName = "JCB"
            case .MasterCard:
                cardTypeName = "MasterCard"
            case .Visa:
                cardTypeName = "VISA"
            default:
                cardTypeName = ""
        }

        return cardTypeName
    }
}
//
//  CreditCardView.m
//  SampleCode
//
//  Created by Thach Bui-Khac on 1/27/15.
//  Copyright (c) 2015 MyID. All rights reserved.
//