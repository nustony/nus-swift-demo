//
//  KNBaseTableViewController.h
//
//  Created by NUS Technology on 8/18/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//
import UIKit
class BaseTableViewController: UITableViewController {
    var appDelegate: AppDelegate
    var originTitleView: UIView

    convenience override init(style: UITableViewStyle) {
        super.init(style: style)
                // Custom initialization
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // set font and style for navigation item title
        self.navigationController.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : AppearanceManager.navigationBarItemTint(),
            NSFontAttributeName : UIFont(name: kCondensedBoldFontName, size: kBigFontSize)
        ]

        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSForegroundColorAttributeName : AppearanceManager.navigationBarItemTint(),
            NSFontAttributeName : UIFont(name: kLightFontName, size: kDefaultFontSize)
        ]
, forState: .Normal)
        // Set disabled status
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSForegroundColorAttributeName : UIColor.grayColor(),
            NSFontAttributeName : UIFont(name: kLightFontName, size: kDefaultFontSize)
        ]
, forState: .Disabled)
        UIBarButtonItem.appearance().tintColor = AppearanceManager.navigationBarItemTint()
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
//  KNBaseTableViewController.m
//
//  Created by NUS Technology on 8/18/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//