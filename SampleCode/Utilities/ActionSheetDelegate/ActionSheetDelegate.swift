//
// ActionSheetDelegate.h
//
// Created by Joshua Caswell on 12/5/11.
// 
// To the extent possible under law, the author has dedicated all
// copyright and related and neighboring rights to this software to 
// the public domain worldwide. This software is distributed without
// any warranty.
// See License.txt for details.
import UIKit
typealias ButtonClickedHandler = () -> Void
class ActionSheetDelegate: NSObject, UIActionSheetDelegate {
    var handler: ButtonClickedHandler

    class func delegateWithHandler(newHandler: ButtonClickedHandler) -> AnyObject {
        return self(handler: newHandler)
    }
    /* Uses objc_setAssociatedObject() to tie self to the passed-in sheet;
     * the delegate will therefore be released when the sheet is deallocated.
     * This obviates the need to keep a reference to the delegate in the scope
     * in which it was created.
     */

    func associateSelfWithSheet(sheet: UIActionSheet) {
        // Tie delegate's lifetime to that of the action sheet
        objc_setAssociatedObject(sheet, sheet_key, self, OBJC_ASSOCIATION_RETAIN)
    }

    convenience override init(handler newHandler: ButtonClickedHandler) {
        super.init()
        if !self {
            return nil
        }
        self.handler = newHandler.copy()
    }
        var sheet_key: Character
    //MARK: -
    //MARK: UIActionSheetDelegate methods

    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        SAFE_BLOCK_INVOKE(handler, actionSheet, buttonIndex)
    }
}
//
//  ActionSheetDelegate.m
//
//  Created by Joshua Caswell on 12/5/11.
// 
// To the extent possible under law, the author has dedicated all
// copyright and related and neighboring rights to this software to 
// the public domain worldwide. This software is distributed without
// any warranty.
// See License.txt for details.

import ObjectiveC
//#define SAFE_BLOCK_INVOKE(b,...) ((b) ? (b)(__VA_ARGS__) : 0)