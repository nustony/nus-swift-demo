//
//  TextField.h
//
//  Created by NUS Technology on 4/11/13.
//  Copyright (c) 2013 NUS Technology. All rights reserved.
//
import UIKit
enum ViewType : Int {
    case Left = 0
    case Right
    case Both
}

protocol TextFieldDelegate: NSObject {
    func didTouchRightButton(sender: AnyObject)

    func didTouchLeftButton(sender: AnyObject)
}
class TextField: UITextField {
    var required: Bool
    var toolbar: UIToolbar
    var scrollView: UIScrollView
    var isDateField: Bool
    var isEmailField: Bool
    weak var tfDelegate: protocol<NSObject, TextFieldDelegate>

    func setPlaceholderText(placeholderString: String) {
        placeHolderTemp = (placeholderString == "") ? " " : placeholderString
        self.attributedPlaceholder = NSAttributedString(string: placeHolderTemp, attributes: [NSForegroundColorAttributeName: placeHolderColor])
    }

    func setDefaultTextField() {
            // Set font for text
        var textFontColor: UIColor = UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1.0)
        var textFont: UIFont = UIFont(name: kRegularFontName, size: kMediumFontSize)
        self.textColor = textFontColor
        self.font = textFont
            // Set font for placeholder
        var placeholderFontColor: UIColor = UIColor.whiteColor()
        var placeholderFont: UIFont = UIFont(name: kLightFontName, size: kMediumFontSize)
        var placeholderFontDic: [NSObject : AnyObject] = [NSForegroundColorAttributeName: placeholderFontColor, NSFontAttributeName: placeholderFont]
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder == nil ? "" : self.placeholder, attributes: placeholderFontDic)
        // set color for cursor
        self.tintColor = UIColor.whiteColor()
        // clear back color
        self.backgroundColor = UIColor.clearColor()
        // set border
        self.layer.borderColor = kDefaultBorderColor.CGColor
        self.layer.borderWidth = defaultBorderWidth
        self.placeholder = placeHolderTemp == nil ? " " : placeHolderTemp
        placeHolderColor = placeholderFontColor
    }

    func setDefaultTextFieldWithPlaceHolder(placeholder: String) {
        self.placeholderText = placeholder
        self.setDefaultTextField()
    }

    func setBorder() {
        // set border
        self.layer.borderColor = kDefaultBorderColor.CGColor
        self.layer.borderWidth = defaultBorderWidth
        //0.5
    }

    func setNoBorder() {
        self.layer.borderWidth = 0.0
    }

    func addImageWithName(imageName: String, forViewType viewType: ViewType) {
        if imageName != nil && !(imageName == "") {
            var scaleSize: CGSize = CGSizeMake(self.frame.size.height, self.frame.size.height)
            var image: UIImage = UIImage(named: imageName)
            UIGraphicsBeginImageContextWithOptions(scaleSize, false, 0.0)
            image.drawInRect(CGRectMake(0, 0, scaleSize.width, scaleSize.height))
            var resizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            var addedView: UIView = UIView()
            addedView.frame = CGRectMake(0, 0, scaleSize.width, scaleSize.height)
            var imagev: UIImageView = UIImageView(image: resizedImage)
            addedView.addSubview(imagev)
            if viewType == .Left || viewType == .Both {
                self.leftViewMode = .Always
                self.leftView = addedView
            }
            if viewType == .Right || viewType == .Both {
                self.rightViewMode = .Always
                self.rightView = addedView
            }
        }
    }

    func addButtonWithTitle(title: String, forViewType viewType: ViewType) {
        if title && !(title == "") {
            var scaleSize: CGSize = CGSizeMake(self.frame.size.height, self.frame.size.height)
            var button: UIButton = UIButton(type: .System)
            button.frame = CGRectMake(0, 0, scaleSize.width, scaleSize.height)
            button.setTitle(title, forState: .Normal)
            if viewType == .Left || viewType == .Both {
                self.leftViewMode = .Always
                button.addTarget(self, action: "leftButtonPressed:", forControlEvents: .TouchUpInside)
                self.leftView = button
            }
            if viewType == .Right || viewType == .Both {
                self.rightViewMode = .Always
                button.addTarget(self, action: "rightButtonPressed:", forControlEvents: .TouchUpInside)
                self.rightView = button
            }
        }
    }

    func addButtonWithImageName(imageName: String, forViewType viewType: ViewType) {
        if imageName && !(imageName == "") {
            var scaleSize: CGSize = CGSizeMake(self.frame.size.height, self.frame.size.height)
            var button: UIButton = UIButton(type: .System)
            button.frame = CGRectMake(0, 0, scaleSize.width, scaleSize.height)
            var image: UIImage = UIImage(named: imageName)
            UIGraphicsBeginImageContextWithOptions(scaleSize, false, 0.0)
            image.drawInRect((CGRectMake(0, 0, scaleSize.width, scaleSize.height)))
            var resizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            button.setImage(resizedImage, forState: .Normal)
            if viewType == .Left || viewType == .Both {
                self.leftViewMode = .Always
                button.addTarget(self, action: "leftButtonPressed:", forControlEvents: .TouchUpInside)
                self.leftView = button
            }
            if viewType == .Right || viewType == .Both {
                self.rightViewMode = .Always
                button.addTarget(self, action: "rightButtonPressed:", forControlEvents: .TouchUpInside)
                self.rightView = button
            }
        }
    }

    func addTitleForLeftView(title: String, andTextColor color: UIColor) {
        if title && (title == "") {
            self.leftViewMode = .Always
                // get title length in pixel
            var titleFont: UIFont = UIFont(name: kRegularFontName, size: kMediumFontSize)
            var titleLabel: UILabel = UILabel()
            titleLabel.font = titleFont
            if !color {
                titleLabel.textColor = kTextFieldFontColor
            }
            else {
                titleLabel.textColor = color
            }
            titleLabel.text = title
                // get frame for label
            var fAlignText: CGFloat = kLeftMargin
            var fWidth: CGFloat = self.getTextLengthInPixel(title, withFont: titleFont)
            var frame: CGRect = CGRectMake(fAlignText, 0, fWidth + fAlignText, CGRectGetHeight(self.frame))
            titleLabel.frame = frame
            var vContainerView: UIView = UIView(frame: CGRectMake(0, 0, fWidth + 2 * fAlignText, CGRectGetHeight(self.frame)))
            vContainerView.addSubview(titleLabel)
            self.leftView = vContainerView
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

    override func setup() {
        defaultBorderWidth = kDefaultBorderWidth
        if self.isIphone6Plus() == true {
            defaultBorderWidth = kDefaultBorderWidthForIphone6Plus
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldDidBeginEditing:", name: UITextFieldTextDidBeginEditingNotification, object: self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldDidEndEditing:", name: UITextFieldTextDidEndEditingNotification, object: self)
        toolbar = UIToolbar()
        toolbar.frame = CGRectMake(0, 0, self.window.frame.size.width, 44)
        // set style
        toolbar.barStyle = .Default
        self.previousBarButton = UIBarButtonItem(title: "Previous", style: .Bordered, target: self, action: "previousButtonIsClicked:")
        self.nextBarButton = UIBarButtonItem(title: "Next", style: .Bordered, target: self, action: "nextButtonIsClicked:")
        var flexBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        var doneBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneButtonIsClicked:")
        var barButtonItems: [AnyObject] = [self.previousBarButton, self.nextBarButton, flexBarButton, doneBarButton]
        toolbar.items = barButtonItems
        self.textFields = [AnyObject]()
        self.markTextFieldsWithTagInView(self.superview)
        //    self.rightViewMode = UITextFieldViewModeAlways;
        self.leftViewMode = .Always
        var paddingView: UIView = UIView(frame: CGRectMake(0, 0, kLeftMargin, CGRectGetHeight(self.frame)))
        self.leftView = paddingView
        //    self.rightView = paddingView;
        placeHolderTemp = " "
        placeHolderColor = UIColor.blackColor()
        placeHolderTemp = self.placeholder == nil ? " " : self.placeholder
        self.attributedPlaceholder = NSAttributedString(string: placeHolderTemp, attributes: [NSForegroundColorAttributeName: placeHolderColor])
    }

    func markTextFieldsWithTagInView(view: UIView) {
        var index: Int = 0
        if self.textFields.count == 0 {
            for subView: UIView in view.subviews {
                if (subView is TextField.self) {
                    var textField: TextField = (subView as! TextField)
                    textField.tag = index
                    self.textFields.append(textField)
                    index++
                }
            }
        }
    }

    func doneButtonIsClicked(sender: AnyObject) {
        self.doneCommand = true
        self.resignFirstResponder()
        self.toolbarCommand = true
    }
    func animationOptionsWithCurve() -> inline UIViewAnimationOptions {
        var opt: UIViewAnimationOptions = (curve as! UIViewAnimationOptions)
        return opt << 16
    }

    func keyboardDidShow(notification: NSNotification) {
        if textField == nil {
            return
        }
        if !(textField is TextField.self) {
            return
        }
        var notificationInfo: [NSObject : AnyObject] = notification.userInfo!
        var finalKeyboardFrame: CGRect = (notificationInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect).CGRectValue
        var keyboardAnimationDuration: NSTimeInterval = CDouble((notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval))!
        var keyboardAnimationCurveNumber: Int = CInteger((notificationInfo[UIKeyboardAnimationCurveUserInfoKey] as! Int))!
        var animationOptions: UIViewAnimationOptions = animationOptionsWithCurve(keyboardAnimationCurveNumber)
        self.keyboardSize = finalKeyboardFrame.size
        // resize frame for scroll view
        if self.getKeyboardIsShown() == false {
            if (self.superview is UIScrollView.self) {
                UIView.animateWithDuration(keyboardAnimationDuration, delay: 0, options: animationOptions, animations: {() -> Void in
                    self.calculateKeyboardHeightForScrollViewForStatus(true)
                    self.scrollToField(false)
                }, completion: { _ in })
            }
        }
        else {
            if (self.superview is UIScrollView.self) {
                self.scrollToField(true)
            }
        }
        self.keyboardStatusToHidden = true
        self.keyboardIsShown = true
    }

    func keyboardWillHide(notification: NSNotification) {
        var info: [NSObject : AnyObject] = notification.userInfo!
        var duration: NSTimeInterval = CDouble(info[UIKeyboardAnimationDurationUserInfoKey])!
        UIView.animateWithDuration(duration, animations: {() -> Void in
            if self.isDoneCommand || true {
                if (self.superview is UIScrollView.self) {
                    self.scrollView.setContentOffset(CGPointMake(0, 0), animated: false)
                }
            }
        })
        // resize frame for scroll view
        if self.getKeyboardIsShown() {
            if (self.superview is UIScrollView.self) {
                self.calculateKeyboardHeightForScrollViewForStatus(false)
            }
        }
        self.keyboardStatusToHidden = true
        self.keyboardIsShown = false
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self)
    }

    func nextButtonIsClicked(sender: AnyObject) {
        var tagIndex: Int = self.tag
        var textField: TextField = self.textFields[++tagIndex]
        while !textField.isEnabled && tagIndex < self.textFields.count {
            textField = self.textFields[++tagIndex]
        }
        self.becomeActive(textField)
    }

    func previousButtonIsClicked(sender: AnyObject) {
        var tagIndex: Int = self.tag
        var textField: TextField = self.textFields[--tagIndex]
        while !textField.isEnabled && tagIndex < self.textFields.count {
            textField = self.textFields[--tagIndex]
        }
        self.becomeActive(textField)
    }

    func becomeActive(textField: UITextField) {
        self.toolbarCommand = true
        self.resignFirstResponder()
        textField.becomeFirstResponder()
    }

    func setBarButtonNeedsDisplayAtTag(tag: Int) {
        var previousBarButtonEnabled: Bool = false
        var nexBarButtonEnabled: Bool = false
        for var index = 0; index < self.textFields.count; index++ {
            var textField: UITextField = self.textFields[index]
            if index < tag {
                previousBarButtonEnabled |= textField.isEnabled
            }
            else if index > tag {
                nexBarButtonEnabled |= textField.isEnabled
            }
        }
        self.previousBarButton.enabled = previousBarButtonEnabled
        self.nextBarButton.enabled = nexBarButtonEnabled
    }

    func selectInputView(textField: UITextField) {
        if isDateField {
            var datePicker: UIDatePicker = UIDatePicker()
            datePicker.datePickerMode = .Date
            datePicker.addTarget(self, action: "datePickerValueChanged:", forControlEvents: .ValueChanged)
            if !(textField.text! == "") {
                var dateFormatter: NSDateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM/dd/YY"
                dateFormatter.timeZone = NSTimeZone.localTimeZone()
                dateFormatter.dateStyle = NSDateFormatterShortStyle
                datePicker.date = dateFormatter.dateFromString(textField.text!)
            }
            textField.inputView = datePicker
        }
    }

    func datePickerValueChanged(sender: AnyObject) {
        var datePicker: UIDatePicker = (sender as! UIDatePicker)
        var selectedDate: NSDate = datePicker.date
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY"
        textField.text = dateFormatter.stringFromDate(selectedDate)
        self.validate()
    }

    func scrollToField(animated: Bool) {
        if textField == nil {
            return
        }
        var textFieldRect: CGRect = textField.frame
        var aRect: CGRect = self.window.bounds
        aRect.origin.y = -scrollView.contentOffset.y
        var toolbarHeight: CGFloat = self.toolbar.frame.size.height
        if self.toolbar.hidden {
            toolbarHeight = 0
        }
        aRect.size.height -= self.keyboardSize.height + toolbarHeight
        var textRectBoundary: CGPoint = CGPointMake(textFieldRect.origin.x, textFieldRect.origin.y + textFieldRect.size.height + 20)
        if !CGRectContainsPoint(aRect, textRectBoundary) || scrollView.contentOffset.y >= 0 {
            var scrollPoint: CGPoint = CGPointMake(0.0, self.superview.frame.origin.y + textField.frame.origin.y + 20 - aRect.size.height)
            if scrollPoint.y < 0 {
                scrollPoint.y = 0
            }
            scrollView.setContentOffset(scrollPoint, animated: animated)
        }
    }

    func validate() -> Bool {
        //self.backgroundColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:0.5];
        if required && (self.text! == "") {
            return false
        }
        else if isEmailField {
            var emailRegEx: String = "(?:[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}" + 
                    "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + 
                    "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[A-Za-z0-9](?:[a-" + 
                    "z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?|\\[(?:(?:25[0-5" + 
                    "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + 
                    "9][0-9]?|[A-Za-z0-9-]*[A-Za-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + 
                    "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
            var emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
            if !emailTest.evaluateWithObject(self.text!) {
                return false
            }
        }

        //[self setBackgroundColor:[UIColor whiteColor]];
        return true
    }

    func setEnabled(enabled: Bool) {
        super.enabled = enabled
        if !enabled {
            self.backgroundColor = UIColor.lightGrayColor()
        }
    }

    override func textFieldDidBeginEditing(notification: NSNotification) {
        var textField: UITextField = (notification.object as! UITextField)
        self.textField = textField
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        self.barButtonNeedsDisplayAtTag = Int(textField.tag)
        if (self.superview is UIScrollView.self) && self.scrollView == nil {
            self.scrollView = (self.superview as! UIScrollView)
        }
        self.selectInputView(textField)
        self.inputAccessoryView = toolbar
        self.doneCommand = false
        self.toolbarCommand = false
        self.attributedPlaceholder = NSAttributedString(string: " ", attributes: [NSForegroundColorAttributeName: UIColor.clearColor()])
    }

    func textFieldDidEndEditing(notification: NSNotification) {
        var textField: UITextField = (notification.object as! UITextField)
        self.validate()
        self.textField = nil
        if isDateField && (textField.text! == "") && isDoneCommand {
            var dateFormatter: NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd/YY"
            textField.text = dateFormatter.stringFromDate(NSDate())
        }
        self.attributedPlaceholder = NSAttributedString(string: placeHolderTemp, attributes: [NSForegroundColorAttributeName: placeHolderColor])
    }

    func getKeyboardIsShown() -> Bool {
        for var i = 0; i < self.textFields.count; ++i {
            var tf: TextField = self.textFields[i]
            if tf.keyboardIsShown {
                return true
            }
        }
        return false
    }

    func calculateKeyboardHeightForScrollViewForStatus(isShown: Bool) {
        if isShown {
            var bkgndSize: CGSize = self.scrollView.contentSize
            bkgndSize.height += self.keyboardSize.height
            self.scrollView.contentSize = bkgndSize
            self.isKeyboardHeightCalculated = true
        }
        else {
            for var i = 0; i < self.textFields.count; ++i {
                var tf: TextField = self.textFields[i]
                if tf.isKeyboardHeightCalculated {
                    var bkgndSize: CGSize = self.scrollView.contentSize
                    bkgndSize.height -= tf.keyboardSize.height
                    self.scrollView.contentSize = bkgndSize
                    tf.isKeyboardHeightCalculated = false
                }
            }
        }
    }

    func setKeyboardStatusToHidden(isHidden: Bool) {
        for var i = 0; i < self.textFields.count; ++i {
            var tf: TextField = self.textFields[i]
            tf.keyboardIsShown = !isHidden
        }
    }

    func isIphone6Plus() -> Bool {
        return (UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenHeight >= 736.0)
    }

    func rightButtonPressed(sender: AnyObject) {
        if self.tfDelegate && self.tfDelegate.respondsToSelector("didTouchRightButton:") {
            self.tfDelegate.didTouchRightButton(self)
        }
    }

    func leftButtonPressed(sender: AnyObject) {
        if self.tfDelegate && self.tfDelegate.respondsToSelector("didTouchLeftButton:") {
            self.tfDelegate.didTouchLeftButton(self)
        }
    }

    func getTextLengthInPixel(text: String, withFont font: UIFont) -> CGFloat {
        var tempLabel: UILabel = UILabel()
        tempLabel.text = text
        tempLabel.font = font
        tempLabel.numberOfLines = 1
        var maximumLabelSize: CGSize = CGSizeMake(200, 9999)
        var expectedSize: CGSize = tempLabel.sizeThatFits(maximumLabelSize)
        return expectedSize.width
    }
    //MARK initializers to setup
    // MARK - add text for right view
    var textField: UITextField
    var disabled: Bool
    var placeHolderTemp: String
    var placeHolderColor: UIColor
    var defaultBorderWidth: Float


    var keyboardIsShown: Bool
    var keyboardSize: CGSize
    var isKeyboardHeightCalculated: Bool
    var hasScrollView: Bool
    var invalid: Bool
    var isToolBarCommand: Bool
    var isDoneCommand: Bool
    var previousBarButton: UIBarButtonItem
    var nextBarButton: UIBarButtonItem
    var textFields: [AnyObject]
}
//
//  TextField.m
//
//  Created by NUS Technology on 4/11/13.
//  Copyright (c) 2013 NUS Technology. All rights reserved.
//

let kDefaultBorderWidth = 0.5
let kDefaultBorderWidthForIphone6Plus = 1.0
let kDefaultBorderColor = UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 0.5)
let kLeftMargin = 15.0