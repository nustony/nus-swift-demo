//
//  UserManager.h
//  NUS Technology
//
//  Created by NUS Technology on 6/20/14.
//
//
// Manager of current user info
import Foundation
class UserManager: NSObject {
    // Get singleton instance
    class func sharedInstance() -> UserManager {
        var sharedInstance: AnyObject? = nil
            var onceToken: dispatch_once_t
        dispatch_once(onceToken, {() -> Void in
            sharedInstance = self()
        })
        return (sharedInstance as! UserManager)
    }

    func currentUser() -> User {
        var accessToken: String = UICKeyChainStore.stringForKey(kKeychainAccessToken)
        if accessToken == nil || (accessToken == "") {
            return nil
        }
        var userId: String = UICKeyChainStore.stringForKey(kKeyChainUserId)
        var u: User = User.fetchUser(userId)
        return u
    }
}
//
//  UserManager.m
//  NUS Technology
//
//  Created by NUS Technology on 6/20/14.
//
//