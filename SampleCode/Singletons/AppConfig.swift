//
//  AppConfig.h
// Sample Code
//
//  Created by NUS Technology
//  Copyright (c) 2013 Sample Code, LLC. All rights reserved.
//
import Foundation
class AppConfig: NSObject {
    class func forKey(key: String) -> AnyObject {
        return (self.sharedConfig().config()[key] as! String)
    }

    class func sharedConfig() -> AnyObject {
            var onceToken: dispatch_once_t
        var sharedConfig: AppConfig? = nil
        dispatch_once(onceToken, {() -> Void in
            sharedConfig = self()
            sharedConfig!.loadConfig()
        })
        return sharedConfig!
    }

    func loadConfig() {
        self.env = (NSBundle.mainBundle().infoDictionary!["Configuration"] as! String)
        var appConfigPath: String = NSBundle.mainBundle().pathForResource("AppConfig", ofType: "plist")
        var appConfig: [NSObject : AnyObject] = [NSObject : AnyObject](contentsOfFile: appConfigPath)
        var envConfig: [NSObject : AnyObject] = (appConfig["Default"] as! [NSObject : AnyObject]).mutableCopy()
        (appConfig[self.env] as! String).enumerateKeysAndObjectsUsingBlock({(key: AnyObject, obj: AnyObject, stop: Bool) -> Void in
            envConfig[key] = obj
        })
        self.config = envConfig.copy()
    }

    var config: [NSObject : AnyObject]
    var env: String
}
//
//  AppConfig.m
// Sample Code
//
//  Created by NUS Technology
//  Copyright (c) 2013 Sample Code, LLC. All rights reserved.
//