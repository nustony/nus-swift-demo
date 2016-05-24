//
//  AppDelegate.h
//  Sample Code
//
//  Created by NUS Technology on 12/1/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//
import UIKit
import CoreData
// LoginViewControllerDelegate
protocol LoginViewControllerDelegate: NSObject {
    func didLogin()

    func didLogout()
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LoginViewControllerDelegate {
    var window: UIWindow!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        AnalyticsManager.beginSession()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
    }

    func didLogin() {
        NSLog("User logged in!!!")
        self.goToHome()
    }

    func didLogout() {
        NSLog("User logged out!!!")
    }

    func goToHome() {
        var VC: UIViewController = StoryboardManager.getViewControllerWithIdentifier(kHomeViewControllerId, fromStoryboard: kMainStoreyboard)
        self.window.rootViewController = VC
    }
}
//
//  AppDelegate.m
//  Sample Code
//
//  Created by NUS Technology on 12/1/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//