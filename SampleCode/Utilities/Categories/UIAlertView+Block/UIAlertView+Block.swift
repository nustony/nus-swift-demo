//
//  UIAlertView+Block.h
//
//  Created by NUS Technology on 9/9/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//
import UIKit
extension UIAlertView {
    func showWithCompletion(completion: () -> Void) {
        var alertWrapper: AlertWrapper = AlertWrapper()
        alertWrapper.completionBlock = completion
        self.delegate = alertWrapper
        // Set the wrapper as an associated object
        objc_setAssociatedObject(self, kAlertWrapper, alertWrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.show()
    }
}
//
//  UIAlertView+Block.m
//
//  Created by NUS Technology on 9/9/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//
import ObjectiveC
class AlertWrapper: NSObject, UIAlertViewDelegate {
    var completionBlock: Void

    // Called when a button is clicked. The view will be automatically dismissed after this call returns
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if self.completionBlock {
            self.completionBlock(alertView, buttonIndex)
        }
    }
    // Called when we cancel a view. This is not called when the user clicks the cancel button.
    // If not defined in the delegate, we simulate a click in the cancel button

    func alertViewCancel(alertView: UIAlertView) {
        if self.completionBlock {
            self.completionBlock(alertView, alertView.cancelButtonIndex)
        }
    }
}
    let kAlertWrapper: Character