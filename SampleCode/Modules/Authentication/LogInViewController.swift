//
//  LogInViewController.h
//
//  Created by NUS Technology on 10/17/14.
//  Copyright (c) 2014 Sample Code, LLC. All rights reserved.
//
import UIKit
class LogInViewController: BaseViewController {
    weak var delegate: LoginViewControllerDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self.appDelegate
        self.tfEmail.placeholderText = "Email"
        self.tfPassword.placeholderText = "Password"
        self.tfEmail.setDefaultTextField()
        self.tfPassword.setDefaultTextField()
        self.tfEmail.setBorder()
        self.tfPassword.setBorder()
    }
    //- (void)viewDidLayoutSubviews
    //{
    //    [super viewDidLayoutSubviews];
    //    
    ////    NSAttributedString *passwordPlaceholder = [[NSAttributedString alloc] initWithString:LOCALIZATION(@"Password") attributes:@{ NSForegroundColorAttributeName : kTextFieldFontColor }];
    ////    NSAttributedString *emailPlaceholder = [[NSAttributedString alloc] initWithString:LOCALIZATION(@"Email") attributes:@{ NSForegroundColorAttributeName : kTextFieldFontColor }];
    ////    
    ////    self.tfPassword.attributedPlaceholder = passwordPlaceholder;
    ////    self.tfEmail.attributedPlaceholder = emailPlaceholder;
    ////    self.tfEmail.placeholder = @"abc";
    //    
    ////    [self.tfEmail setPlaceholderText:@"Email1"];
    //    
    ////    [self.tfPassword setPlaceholder:@"Password"];
    //    
    //    // set border for textfield
    ////    [self.tfEmail setBorder];
    ////    [self.tfPassword setBorder];
    //}

    func viewDidUnload() {
        self.tfEmail = nil
        self.tfPassword = nil
        super.viewDidUnload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func goToHome() {
        var VC: UIViewController = StoryboardManager.getViewControllerWithIdentifier(kHomeViewControllerId, fromStoryboard: kMainStoreyboard)
        self.presentViewController(VC, animated: true, completion: { _ in })
    }

    @IBAction func login(sender: UIButton) {
        // Hide keyboard
        self.view!.endEditing(true)
        if !self.validateInput() {
            UIAlertView(title: nil, message: LOCALIZATION("lackInputParameter"), delegate: nil, cancelButtonTitle: LOCALIZATION("ok"), otherButtonTitles: "").show()
            return
        }
        var myClient: APIClient = APIClient.sharedInstance()
        MBProgressHUD.showHUDAddedTo(self.view!, animated: true)
        //authentication
        myClient.authorizeWithUsername(self.tfEmail.text!, password: self.tfPassword.text!, success: {(successful: Bool) -> Void in
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
            var errorMessage: String = error.localizedDescription
            //LOCALIZATION(@"incorrectUserNameOrPassword");
            UIAlertView(title: nil, message: errorMessage, delegate: nil, cancelButtonTitle: LOCALIZATION("ok"), otherButtonTitles: "").show()
            AnalyticsManager.sendErrorWithTitle(LOCALIZATION("loginFailedTitle"), message: errorMessage, andError: error!)
        })
    }

    @IBAction func forgotPassword(sender: UIButton) {
        self.performSegueWithIdentifier("segueForgotPassword", sender: self)
    }

    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView == self.forgotPassword {
            if buttonIndex == 0 {
                self.performSegueWithIdentifier("segueForgotPassword", sender: self)
            }
        }
    }

    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
    }

    @IBAction func unwindToLogInViewController(unwindSegue: UIStoryboardSegue) {
    }

    func validateInput() -> Bool {
        if self.tfPassword.text.length > 0 && self.tfEmail.text.length > 0 {
            return true
        }
        return false
    }


    @IBOutlet weak var tfEmail: TextField!
    @IBOutlet weak var tfPassword: TextField!
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var btnForgotPassword: UIButton!
    @IBOutlet var btnSignUp: UIButton!
    var forgotPassword: UIAlertView {
        get {
            self.performSegueWithIdentifier("segueForgotPassword", sender: self)
        }
    }
}
//
//  LogInViewController.m
//
//  Created by NUS Technology on 10/17/14.
//  Copyright (c) 2014 Sample Code, LLC. All rights reserved.
//