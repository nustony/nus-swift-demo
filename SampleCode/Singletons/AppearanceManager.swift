//
//  AppearanceManager.h
// Sample Code
//
//  Created by NUS Technology
//  Copyright (c) 2013 Sample Code, LLC. All rights reserved.
//
import Foundation
import UIKit
class AppearanceManager: NSObject {
    class func navigationBarTint() -> UIColor {
        return UIColor(red: 0 / 255.0, green: 142 / 255.0, blue: 207 / 255.0, alpha: 1.0)
    }

    class func navigationBarItemTint() -> UIColor {
        return UIColor(red: 255.0 / 255, green: 255.0 / 255, blue: 255.0 / 255, alpha: 1.0)
    }

    class func blueTextColor() -> UIColor {
        return UIColor(red: 0 / 255.0, green: 172 / 255.0, blue: 215 / 255.0, alpha: 1.0)
    }

    class func backgroundColor() -> UIColor {
        return UIColor(red: 19.0 / 255.0, green: 151.0 / 255.0, blue: 198.0 / 255.0, alpha: 1)
    }

    class func tableCellBackgroundColor() -> UIColor {
        return UIColor(red: 227 / 255.0, green: 226 / 255.0, blue: 232 / 255.0, alpha: 1.0)
    }

    class func borderColor() -> UIColor {
        return UIColor(red: 186 / 255.0, green: 186 / 255.0, blue: 186 / 255.0, alpha: 1.0)
    }

    class func disableBackgroundColor() -> UIColor {
        return UIColor(red: 210 / 255.0, green: 210 / 255.0, blue: 210 / 255.0, alpha: 1.0)
    }

    class func navigationTitleImageView() -> UIImageView {
        return UIImageView(image: UIImage(named: "logo_icon"))
    }

    class func boldAppFontOfSize(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Bold", size: fontSize)
    }

    class func appFontOfSize(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue", size: fontSize)
    }

    class func bannerImageLocation() -> String {
        return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0].stringByAppendingPathComponent("bannerImage.jpg")
    }

    class func footerColor() -> UIColor {
        return UIColor(hexString: "#EBEAF1")
    }

    class func selectedCellColor() -> UIColor {
        return UIColor(hexString: "#d4d3d8")
    }

    class func setBasicAppearanceForViewController(vc: UIViewController) {
        // set font and style for navigation item title
        vc.navigationController.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : AppearanceManager.navigationBarItemTint(),
            NSFontAttributeName : UIFont(name: kRegularFontName, size: kBigFontSize)
        ]

        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSForegroundColorAttributeName : AppearanceManager.navigationBarItemTint(),
            NSFontAttributeName : UIFont(name: kLightFontName, size: kDefaultFontSize)
        ]
, forState: .Normal)
        UIBarButtonItem.appearance().tintColor = AppearanceManager.navigationBarItemTint()
        // Set disabled status
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSForegroundColorAttributeName : UIColor.grayColor(),
            NSFontAttributeName : UIFont(name: kLightFontName, size: kDefaultFontSize)
        ]
, forState: .Disabled)
        vc.navigationController.navigationBar.tintColor = AppearanceManager.navigationBarItemTint()
        // Set title of Back button to empty
        vc.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Bordered, target: nil, action: nil)
        vc.navigationController.navigationBar.barTintColor = AppearanceManager.navigationBarTint()
        // Set background color for view
        vc.view.backgroundColor = AppearanceManager.backgroundColor()
        // Set Title View
        //vc.originTitleView = vc.navigationItem.titleView;
        vc.navigationItem.titleView = AppearanceManager.navigationTitleImageView()
    }

    class func addNoInternetConnectionViewInView(view: UIView) -> UIView {
        if !noInternetConnectionView {
            var nibArray: [AnyObject] = NSBundle.mainBundle().loadNibNamed("NoInternetConnection", owner: nil, options: nil)
            noInternetConnectionView = nibArray[0]
            noInternetConnectionView.frame = CGRectMake(0, 20, ScreenWidth, 24.0)
            var noNetworkLabel: UILabel = noInternetConnectionView.noInternetLabel
            noInternetConnectionView.noInternetLabel.frame = CGRectMake((CGRectGetWidth(noInternetConnectionView.frame) - CGRectGetWidth(noNetworkLabel.frame)) / 2 - CGRectGetWidth(noInternetConnectionView.noInternetIcon.frame) / 2, CGRectGetMinY(noNetworkLabel.frame), CGRectGetWidth(noNetworkLabel.frame), CGRectGetHeight(noNetworkLabel.frame))
            var iconFrm: CGRect = noInternetConnectionView.noInternetIcon.frame
            iconFrm.origin.x = CGRectGetMaxX(noInternetConnectionView.noInternetLabel.frame) + 1
            noInternetConnectionView.noInternetIcon.frame = iconFrm
        }
        if noInternetConnectionView.superview() {
            noInternetConnectionView.removeFromSuperview()
        }
        view.addSubview(noInternetConnectionView)
        return noInternetConnectionView
    }

    class func removeNoInternetConnectionView() {
        if noInternetConnectionView {
            noInternetConnectionView.removeFromSuperview()
        }
    }

    class func lightAppFontOfSize(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Light", size: fontSize)
    }


    var noInternetConnectionView: NoInternetConnectionView
}
//
//  AppearanceManager.m
// Sample Code
//
//  Created by NUS Technology
//  Copyright (c) 2013 Sample Code, LLC. All rights reserved.
//