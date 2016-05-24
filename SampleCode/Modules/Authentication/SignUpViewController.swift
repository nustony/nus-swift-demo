//
//  SignUpViewController.h
//
//  Created by NUS Technology on 10/20/14.
//  Copyright (c) 2014 Sample Code, LLC. All rights reserved.
//
import UIKit
class SignUpViewController: BaseViewController, UITextFieldDelegate {
    weak var delegate: LoginViewControllerDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppearanceManager.backgroundColor()
        self.delegate = self.appDelegate
    }

    func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.submitButton.setTitle(LOCALIZATION("submit"), forState: .Normal)
        self.cancelButton.setTitle(LOCALIZATION("cancel"), forState: .Normal)
        var emailPlaceholder: NSAttributedString = NSAttributedString(string: LOCALIZATION("email"), attributes: [NSForegroundColorAttributeName: kTextFieldFontColor])
        var passwordPlaceholder: NSAttributedString = NSAttributedString(string: LOCALIZATION("password"), attributes: [NSForegroundColorAttributeName: kTextFieldFontColor])
        var confirmPasswordPlaceholder: NSAttributedString = NSAttributedString(string: LOCALIZATION("confirmPassword"), attributes: [NSForegroundColorAttributeName: kTextFieldFontColor])
        self.tfEmail.attributedPlaceholder = emailPlaceholder
        self.tfPassword.attributedPlaceholder = passwordPlaceholder
        self.tfConfirmPassword.attributedPlaceholder = confirmPasswordPlaceholder
        // set border for textfield
        self.tfEmail.setBorder()
        self.tfPassword.setBorder()
        self.tfConfirmPassword.setBorder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signUp(sender: UIButton) {
        self.dismissKeyboards()
        if !self.validateInput() {
            return
        }
        var userDictionary: [NSObject : AnyObject] = [NSObject : AnyObject](dictionary: ["user": ["email": self.tfEmail.text, "password": self.tfPassword.text, "password_confirmation": self.tfConfirmPassword.text]])
        var theClient: APIClient = APIClient.sharedInstance()
        theClient.signUpWithParameters(userDictionary, success: {(successful: Bool) -> Void in
            MBProgressHUD.hideHUDForView(self.view!, animated: true)
            if successful {
                self.delegate.didLogin()
                var user: User = User()
                user.email = self.tfEmail.text!
                user.password = self.tfPassword.text!
                user.self.saveLocalItems([user])
            }
        }, failure: {(error: NSError) -> Void in
            MBProgressHUD.hideHUDForView(self.view!, animated: true)
            var msgTitle: String = LOCALIZATION("signUpTitle")
            var errorMessage: String = error.localizedDescription
            //some part of the sign up failed
            UIAlertView(title: msgTitle, message: errorMessage, delegate: nil, cancelButtonTitle: LOCALIZATION("ok"), otherButtonTitles: "").show()
            AnalyticsManager.sendErrorWithTitle(nil, message: error.localizedDescription, andError: error!)
        })
    }
    // Go to Splash screen

    @IBAction func cancelSignup(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: { _ in })
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
        if self.tfPassword.text.length < 1 {
            Utilities.sharedInstance().showOKMessage(LOCALIZATION("blankPasswordMsg"), withTitle: nil)
            return false
        }
        if self.tfPassword.text.length < 6 {
            Utilities.sharedInstance().showOKMessage(LOCALIZATION("invalidMininumLengthPasswordMsg"), withTitle: nil)
            return false
        }
        if !(self.tfPassword.text! == self.tfConfirmPassword.text!) {
            Utilities.sharedInstance().showOKMessage(LOCALIZATION("invalidConfirmMsg"), withTitle: nil)
            return false
        }
        return true
    }

    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
    }

    func dismissKeyboards() {
        self.tfEmail.resignFirstResponder()
        self.tfPassword.resignFirstResponder()
        self.tfConfirmPassword.resignFirstResponder()
    }

    func goToHome() {
        var VC: UIViewController = StoryboardManager.getViewControllerWithIdentifier(kHomeViewControllerId, fromStoryboard: kMainStoreyboard)
        self.presentViewController(VC, animated: true, completion: { _ in })
    }
    var isHideInput: Bool
    var group: UIMotionEffectGroup


    @IBOutlet weak var tfEmail: TextField!
    @IBOutlet weak var tfPassword: TextField!
    @IBOutlet weak var tfConfirmPassword: TextField!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
}
//
//  SignUpViewController.m
//
//  Created by NUS Technology on 10/20/14.
//  Copyright (c) 2014 Sample Code, LLC. All rights reserved.
//

import CoreImage
import QuartzCore
enum TextType : Int {
    case Email = 0
    case Password
    case PasswordConfirmation
}