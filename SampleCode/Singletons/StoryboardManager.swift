//
//  KNStoryboardManager.h
//  NUS Technology
//
//  Created by NUS Technology on 6/26/14.
//
//
// Manager to control storyboard
import Foundation
class StoryboardManager: NSObject {
    // Get main storyboard name based on device
    class func getMainStoryboardName() -> String {
        if UIDevice.currentDevice().userInterfaceIdiom() == .Pad {
            return kMainStoryboardName_iPad
        }
        else {
            return kMainStoryboardName_iPhone
        }
    }

    class func getViewControllerWithIdentifier(viewControllerIdentifier: String, fromStoryboard storyboardName: String) -> UIViewController {
            // Getting the storyboard
        var storyboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
            // get certain ViewController
        var vc: UIViewController = storyboard.instantiateViewControllerWithIdentifier(viewControllerIdentifier)
        return vc
    }

    class func getViewControllerInitial(storyboardName: String) -> UIViewController {
            // Getting the storyboard
        var storyboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
            // get instantiate initial view controller
        var vc: UIViewController = storyboard.instantiateInitialViewController
        return vc
    }
}
//
//  KNStoryboardManager.m
//  NUS Technology
//
//  Created by NUS Technology on 6/26/14.
//
//

//#import "KNAppControlManager.h"