//
//  KNSplashTemplateViewController.h
//  NUS Technology
//
//  Created by NUS Technology on 6/26/14.
//
//
// Splash template

class SplashViewController: BaseViewController {
    // next view controller Id.
    var viewControllerIdForNext: String
    // next Storyboard name.
    var storyboardNameForNext: String
    // Splash Time to live
    var timeToLive: CGFloat
    var accumlateTime: CGFloat


    convenience override init() {
        super.init()
                self.timeToLive = kDefaultTimeToLiveSplash
    }

    convenience override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
                // Custom initialization
            self.timeToLive = kDefaultTimeToLiveSplash
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
                self.timeToLive = kDefaultTimeToLiveSplash
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onShouldCloseSplash:", name: kApplicationLoadFinished, object: nil)
        self.timerSplashKill = NSTimer.scheduledTimerWithTimeInterval(kTimerIntervalSplash, target: self, selector: "onTimer:", userInfo: nil, repeats: true)
        accumlateTime = 0
        self.viewControllerIdForNext = kSignInViewControllerId
        self.storyboardNameForNext = kSecurityStoreyboard
    }

    func dealloc() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kApplicationLoadFinished, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onTimer(sender: AnyObject) {
        accumlateTime += kTimerIntervalSplash
        if accumlateTime >= self.timeToLive {
            // Timer expired
            self.timerSplashKill.invalidate()
            self.timerSplashKill = nil
            self.goNext(nil)
        }
    }

    func onShouldCloseSplash(notification: NSNotification) {
        self.goNext(notification)
    }

    func goNext(sender: AnyObject) {
        if self.timerSplashKill {
            self.timerSplashKill.invalidate()
            self.timerSplashKill = nil
        }
            //sign in automatically
        var myClient: APIClient = APIClient.sharedInstance()
        if UserManager.sharedInstance().currentUser() {
            MBProgressHUD.showHUDAddedTo(self.view!, animated: true)
            myClient.authorizeWithKeychain({(successful: Bool) -> Void in
                MBProgressHUD.hideHUDForView(self.view!, animated: true)
                if successful {
                    // Go to home view
                    self.storyboardNameForNext = kMainStoreyboard
                    self.viewControllerIdForNext = kHomeViewControllerId
                    // get next view controller
                    self.viewControllerIdForNext = kSignInViewControllerId
                    self.storyboardNameForNext = kSecurityStoreyboard
                    self.goToNextView()
                }
            }, failure: {(error: NSError) -> Void in
                MBProgressHUD.hideHUDForView(self.view!, animated: true)
                if !myClient.isConnected {
                    var errorMessage: String = error.localizedDescription
                    var msgTitle: String = LOCALIZATION("Error")
                    UIAlertView(title: msgTitle, message: errorMessage, delegate: nil, cancelButtonTitle: LOCALIZATION("OK"), otherButtonTitles: "").show()
                }
                // get next view controller
                self.viewControllerIdForNext = kSignInViewControllerId
                self.storyboardNameForNext = kSecurityStoreyboard
                self.goToNextView()
            })
        }
        else {
            // get next view controller
            self.viewControllerIdForNext = kSignInViewControllerId
            self.storyboardNameForNext = kSecurityStoreyboard
            self.goToNextView()
        }
    }

    func goToNextView() {
        var VC: UIViewController = StoryboardManager.getViewControllerWithIdentifier(self.viewControllerIdForNext, fromStoryboard: self.storyboardNameForNext)
        self.appDelegate.window.rootViewController = VC
    }

    var timerSplashKill: NSTimer
}
//
//  KNSplashTemplateViewController.m
//  NUS Technology
//
//  Created by NUS Technology on 6/26/14.
//
//