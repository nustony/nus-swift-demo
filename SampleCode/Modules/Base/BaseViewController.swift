//
//  KNBaseViewController.h
//  NUS Technology
//
//  Created by NUS Technology on 6/20/14.
//
//
// Interface of base view controller.
//
// Add cusomization for all of view controller,
import UIKit
class BaseViewController: UIViewController {
    var appDelegate: AppDelegate
    var originTitleView: UIView

    convenience override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
                // Custom initialization
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //     set font and style for navigation item title
        self.navigationController.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : AppearanceManager.navigationBarItemTint(),
            NSFontAttributeName : UIFont(name: kCondensedBoldFontName, size: kBigFontSize)
        ]

        // Set disabled status
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSForegroundColorAttributeName : UIColor.grayColor(),
            NSFontAttributeName : UIFont(name: kLightFontName, size: kDefaultFontSize)
        ]
, forState: .Disabled)
        self.navigationController.navigationBar.tintColor = AppearanceManager.navigationBarItemTint()
        // Set title of Back button to empty
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Bordered, target: nil, action: nil)
        self.navigationController.navigationBar.barTintColor = AppearanceManager.navigationBarTint()
        // Set background color for view
        self.view.backgroundColor = AppearanceManager.backgroundColor()
        // Set Title View
        self.originTitleView = self.navigationItem.titleView
        self.navigationItem.titleView = AppearanceManager.navigationTitleImageView()
        self.appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "connectionStatusChanged:", name: AFNetworkingReachabilityDidChangeNotification, object: nil)
        self.connectionStatusChanged(nil)
    }

    override func viewDidAppear(animated: Bool) {
        self.connectionStatusChanged(nil)
    }

    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AFNetworkingReachabilityDidChangeNotification, object: nil)
    }

    func connectionStatusChanged(note: NSNotification) {
        var myClient: APIClient = APIClient.sharedInstance()
        if myClient.isConnected {
            AppearanceManager.removeNoInternetConnectionView()
        }
        else {
            AppearanceManager.addNoInternetConnectionViewInView(self.view!)
        }
    }
}
//
//  KNBaseViewController.m
//  NUS Technology
//
//  Created by NUS Technology on 6/20/14.
//
//