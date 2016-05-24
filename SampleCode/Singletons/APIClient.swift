//
//  IDBandAPIClient.h
// Sample Code
//
//  Created by NUS Technology
//  Copyright (c) 2013 Sample Code, LLC. All rights reserved.
//

typealias callSuccessBlock = (data: [NSObject : AnyObject]) -> Void
typealias callFailedBlock = (error: NSError) -> Void
typealias callFailedData = (data: [NSObject : AnyObject], error: NSError) -> Void
class APIClient: AFOAuth2Client {
    class func sharedInstance() -> APIClient {
        var sharedClient: APIClient? = nil
            var onceToken: dispatch_once_t
        dispatch_once(onceToken, {() -> Void in
            self.sharedClient = APIClient(baseURL: NSURL(string: AppConfig.forKey("apiBaseURL"))!, clientID: AppConfig.forKey("clientID"), secret: AppConfig.forKey("clientSecret"))
            var savedCredential: AFOAuthCredential = AFOAuthCredential.retrieveCredentialWithIdentifier(sharedClient.serviceProviderIdentifier)
            if savedCredential.accessToken {
                sharedClient!.setAuthorizationHeaderWithCredential(savedCredential)
            }
            AFNetworkReachabilityManager.sharedManager().startMonitoring()
        })
        return sharedClient!
    }

    func isConnected() -> Bool {
        var currentStatus: AFNetworkReachabilityStatus = AFNetworkReachabilityManager.sharedManager().networkReachabilityStatus
        if currentStatus == .sReachableViaWiFi || currentStatus == .sReachableViaWWAN {
            return true
        }
        else {
            return false
        }
    }

    func authorizeWithKeychain(success: (successful: Bool) -> Void, failure: (error: NSError) -> Void) {
        var oauthPath: String = "\(AppConfig.forKey("apiBaseURL"))\(kOAuthPath)"
        NSLog("%@", oauthPath)
        self.authenticateUsingOAuthWithURLString(oauthPath, username: UICKeyChainStore.stringForKey(kKeychainUserName), password: UICKeyChainStore.stringForKey(kKeyChainPassword), scope: nil, success: {(credential: AFOAuthCredential) -> Void in
            //store the credential for retrieval
            AFOAuthCredential.storeCredential(credential, withIdentifier: self.serviceProviderIdentifier)
            // Authenticated set the authorization
            self.setAuthorizationHeaderWithCredential(credential)
            success(true)
        }, failure: {(error: NSError) -> Void in
            failure(error)
        })
    }

    func authorizeWithUsername(username: String, password: String, success: (successful: Bool) -> Void, failure: (error: NSError) -> Void) {
        var oauthPath: String = "\(AppConfig.forKey("apiBaseURL"))\(kOAuthPath)"
        DLog("%@", oauthPath)
        self.authenticateUsingOAuthWithURLString(oauthPath, username: username, password: password, scope: nil, success: {(credential: AFOAuthCredential) -> Void in
            var JSON: AnyObject = credential.authorizationResponse
            var successString: Bool = CBool(JSON(valueForKeyPath: "success"))!
            if successString {
                //store the credential for retrieval
                AFOAuthCredential.storeCredential(credential, withIdentifier: self.serviceProviderIdentifier)
                // Authenticated set the authorization
                self.setAuthorizationHeaderWithCredential(credential)
                success(true)
            }
            else {
                var error: NSError = NSError.errorWithDomain("IDBandAPI", code: 400, userInfo: [NSLocalizedDescriptionKey: self.errorStringFromAPIJSON(JSON)])
                failure(error)
            }
        }, failure: {(error: NSError) -> Void in
            failure(error)
        })
    }

    func forgotPasswordWithParameters(criteriaDictionary: [NSObject : AnyObject], success: (success: Bool) -> Void, failure: (error: NSError) -> Void) {
        var oauthPath: String = "\(AppConfig.forKey("apiBaseURL"))\("/forgotpassword")"
        self.POST(oauthPath, parameters: criteriaDictionary, success: {(operation: AFHTTPRequestOperation, JSON: AnyObject) -> Void in
            var successString: Bool = CBool(JSON(valueForKeyPath: "success"))!
            if successString {
                success(true)
            }
            else {
                    //unsuccessful sign up
                var error: NSError = NSError.errorWithDomain("IDBandAPI", code: 400, userInfo: [NSLocalizedDescriptionKey: self.errorStringFromAPIJSON(JSON)])
                failure(error)
            }
        }, failure: {(operation: AFHTTPRequestOperation, error: NSError) -> Void in
                //unsuccessful API post
            failure(error)
        })
    }

    func signUpWithParameters(criteriaDictionary: [NSObject : AnyObject], success: (success: Bool) -> Void, failure: (error: NSError) -> Void) {
        var oauthPath: String = "\(AppConfig.forKey("apiBaseURL"))\("/signup")"
        self.POST(oauthPath, parameters: criteriaDictionary, success: {(operation: AFHTTPRequestOperation, JSON: AnyObject) -> Void in
            var successString: Bool = CBool(JSON(valueForKeyPath: "success"))!
            if successString {
                var userObject: AnyObject = (JSON["user"] as! AnyObject)
                var credential: AFOAuthCredential = AFOAuthCredential.credentialWithOAuthToken(userObject["authentication_token"], tokenType: userObject["token_type"], response: userObject)
                AFOAuthCredential.storeCredential(credential, withIdentifier: self.serviceProviderIdentifier)
                // Authenticated set the authorization
                self.setAuthorizationHeaderWithCredential(credential)
                success(true)
            }
            else {
                    //unsuccessful sign up
                var error: NSError = NSError.errorWithDomain("IDBandAPI", code: 400, userInfo: [NSLocalizedDescriptionKey: self.errorStringFromAPIJSON(JSON)])
                failure(error)
            }
        }, failure: {(operation: AFHTTPRequestOperation, error: NSError) -> Void in
                //unsuccessful API post
            failure(error)
        })
    }

    convenience override init(baseURL url: NSURL, clientID: String, secret: String) {
        super.init(baseURL: url, clientID: clientID, secret: secret)
        if !self {
            return nil
        }
        //Accept Header
        self.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
    }
    // Login with username & password
    //Check keychain store

    func checkKeyChainStore() -> Bool {
        if UICKeyChainStore.stringForKey(kKeychainUserName) && UICKeyChainStore.stringForKey(kKeyChainPassword) {
            return true
        }
        return false
    }

    func removeKeyChainStore() {
        UICKeyChainStore.removeItemForKey(kKeychainUserName)
        UICKeyChainStore.removeItemForKey(kKeyChainPassword)
    }
    // Relogin with exists account in keychain

    func setAuthorizationHeaderWithCredential(theCredential: AFOAuthCredential) {
        //set the default authorization header
        self.requestSerializer.setValue("\(theCredential.accessToken)", forHTTPHeaderField: "auth_token")
            // Set email of user
        var email: String = UICKeyChainStore.stringForKey(kKeychainUserName)
        self.requestSerializer.setValue("\(email)", forHTTPHeaderField: "email")
    }

    func errorStringFromAPIJSON(apiJSON: AnyObject) -> String {
        var errorCode: String = apiJSON(valueForKeyPath: "error_code")
        var errorString: String
        if ("0001" == errorCode) {
            errorString = "Parameters missing or blank"
        }
        else if ("0002" == errorCode) {
            errorString = "Validations error"
        }
        else if ("0003" == errorCode) {
            errorString = "URL not found"
        }
        else if ("0004" == errorCode) {
            errorString = "Record not found"
        }
        else if ("0005" == errorCode) {
            errorString = "Access denied"
        }
        else if ("0006" == errorCode) {
            errorString = "Positions are invalid(blank or null)"
        }
        else if ("0007" == errorCode) {
            errorString = "Phone number is invalid"
        }
        else if ("9999" == errorCode) {
            errorString = "Unknown"
        }
        else if ("0101" == errorCode) {
            errorString = "Authentication token or email is wrong"
        }
        else if ("0102" == errorCode) {
            errorString = "Email has already been taken"
        }
        else if ("0103" == errorCode) {
            errorString = "Login with email or password is wrong"
        }
        else if ("0104" == errorCode) {
            errorString = "Sign out unsuccessfully"
        }
        else if ("0105" == errorCode) {
            errorString = "Email not found"
        }
        else if ("0106" == errorCode) {
            errorString = "Current password is wrong"
        }
        else if ("6001" == errorCode) {
            errorString = "Promotion code is invalid"
        }
        else if ("6002" == errorCode) {
            errorString = "Stripe token is invalid"
        }
        else if ("6003" == errorCode) {
            errorString = "Card not found"
        }
        else if ("1001" == errorCode) {
            errorString = "Band product Id is invalid"
        }
        else {
            errorString = "Unknown error"
        }

        return errorString
    }
}
//
//  IDBandAPIClient.m
// Sample Code
//
//  Created by NUS Technology.
//  Copyright (c) 2013 Sample Code, LLC. All rights reserved.
//