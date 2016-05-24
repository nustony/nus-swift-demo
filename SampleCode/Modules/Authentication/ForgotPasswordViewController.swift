//
//  ForgotPasswordViewController.h
// Sample Code
//
//  Created by NUS Technology on 10/24/14.
//  Copyright (c) 2014 Sample Code, LLC. All rights reserved.
//
import UIKit
class ForgotPasswordViewController: BaseViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // set border for textfield
        self.tfEmail.setBorder()
        self.tfEmail.toolbar.hidden = true
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sumitAction(sender: AnyObject) {
        self.dismissKeyboards()
        if !self.validateInput() {
            return
        }
        MBProgressHUD.showHUDAddedTo(self.view!, animated: true)
        var userDictionary: [NSObject : AnyObject] = NSMutableDictionary()
        userDictionary["email"] = self.tfEmail.text!.trim()
        var theClient: APIClient = APIClient.sharedInstance()
        theClient.forgotPasswordWithParameters(userDictionary, success: {(successful: Bool) -> Void in
            MBProgressHUD.hideHUDForView(self.view!, animated: true)
            if successful {
                var alertView: UIAlertView = UIAlertView(title: LOCALIZATION("sentEmailSuccessTitle"), message: LOCALIZATION("checkEmailInformForResetPassword"), delegate: self, cancelButtonTitle: LOCALIZATION("OK"), otherButtonTitles: "")
                alertView.tag = 1010
                alertView.show()
            }
        }, failure: {(error: NSError) -> Void in
            MBProgressHUD.hideHUDForView(self.view!, animated: true)
            var msgTitle: String = LOCALIZATION("forgotPasswordTitle")
            var errorMessage: String = error.localizedDescription
            //some part of the sign up failed
            UIAlertView(title: msgTitle, message: errorMessage, delegate: nil, cancelButtonTitle: LOCALIZATION("OK"), otherButtonTitles: "").show()
            AnalyticsManager.sendErrorWithTitle(nil, message: error.localizedDescription, andError: error!)
        })
    }

    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.tag == 1010 {
            self.dismissViewControllerAnimated(true, completion: { _ in })
        }
    }

    override func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.tfEmail.resignFirstResponder()
        return true
    }

    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        self.tfEmail.resignFirstResponder()
    }

    func validateInput() -> Bool {
        if self.tfEmail.text.length < 1 {
            Utilities.sharedInstance().showOKMessage(LOCALIZATION("blankEmailMsg"), withTitle: nil)
            return false
        }
        if Utilities.sharedInstance().isValidEmail(self.tfEmail.text!) == false {
            Utilities.sharedInstance().showOKMessage(LOCALIZATION("invalidEmailMsg"), withTitle: nil)
            return false
        }
        return true
    }

    func dismissKeyboards() {
        self.tfEmail.resignFirstResponder()
    }
    var isHideInput: Bool
    var group: UIMotionEffectGroup


    @IBOutlet weak var tfEmail: TextField!
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var btnCancel: UIButton!
}
//
//  ForgotPasswordViewController.m
// Sample Code
//
//  Created by NUS Technology on 10/24/14.
//  Copyright (c) 2014 Sample Code, LLC. All rights reserved.
//