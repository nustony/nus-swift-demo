//
//  Constants.h
//  NUS Technology
//
//  Created by NUS Technology on 6/20/14.
//
//
import Foundation
//#define isIphone6Plus      = ([UIDevice currentDevice].userInterfaceIdiom == userInterfaceIdiomPhone && ScreenHeight >= 736.0)
// Stripe
let kStripePUBLISHABLE_KEY = "pk_test_xgWvwr32sARsarrqcrnmOa7k"
let kstripeSECRET_Key = "sk_test_rA3YDeTRKQv4fbJSm7eMx2XD"
let kFirstLineColor = UIColor(red: 196.0 / 255.0, green: 196.0 / 255.0, blue: 196.0 / 255.0, alpha: 1.0)
let kThirdLineColor = UIColor(red: 149.0 / 255.0, green: 149.0 / 255.0, blue: 149.0 / 255.0, alpha: 1.0)
let kSecondLineColor = UIColor(red: 242.0 / 255.0, green: 242.0 / 255.0, blue: 242.0 / 255.0, alpha: 1.0)
let kGradientColor0 = UIColor(red: 205.0 / 255.0, green: 205.0 / 255.0, blue: 205.0 / 255.0, alpha: 1.0)
let kGradientColor1 = UIColor(red: 239.0 / 255.0, green: 239.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
let kLineBorderColor = UIColor(red: 0 / 255.0, green: 142 / 255.0, blue: 207 / 255.0, alpha: 1.0)
let kTabbarBackgroundColor = UIColor(hexString: "#323232")
let kEvenListBackgroundColor = UIColor(red: 234.0 / 255.0, green: 233.0 / 255.0, blue: 239.0 / 255.0, alpha: 1.0)
let kOddListBackgroundColor = UIColor(red: 226.0 / 255.0, green: 226.0 / 255.0, blue: 231.0 / 255.0, alpha: 1.0)
let kTextFieldFontColor = UIColor(red: 243.0 / 255.0, green: 245.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
let kUnselectFeildColor = UIColor(red: 131.0 / 255.0, green: 131.0 / 255.0, blue: 131.0 / 255.0, alpha: 1.0)
let kPasscodeBackgroundColor = UIColor(hexString: "#178FCC")
let kDefaultBorderWidth = 0.5
let kThinBorderHeight = 1.0
let kThickBorderHeight = 1.0
let kViewBackgroundColor = UIColor(red: 234.0 / 255, green: 234.0 / 255, blue: 234.0 / 255, alpha: 1.0)
let kControlBackgroundColor = UIColor(red: 255.0 / 255, green: 255.0 / 255, blue: 255.0 / 255, alpha: 1.0)
let kButtonBackgroundColor = UIColor(red: 16.0 / 255, green: 133.0 / 255, blue: 186.0 / 255, alpha: 1.0)
let kButtonForegroundColor = UIColor(red: 255.0 / 255, green: 255.0 / 255, blue: 255.0 / 255, alpha: 1.0)
let kButtonFontName = "HelveticaNeue-Light"
let kButtonFontSize = 20.0
let kCommonForegroundColor = UIColor(red: 255.0 / 255, green: 255.0 / 255, blue: 255.0 / 255, alpha: 1.0)
let kRegularFontName = "HelveticaNeue"
let kLightFontName = "HelveticaNeue-Light"
let kMediumFontName = "HelveticaNeue-Medium"
let kBoldFontName = "HelveticaNeue-Bold"
let kCondensedBoldFontName = "HelveticaNeue-CondensedBold"
let kBigFontSize = 19.0
let kDefaultFontSize = 17.0
let kMediumFontSize = 14.0
let kSmallFontSize = 12.0
let kPageSize = 25
let kPasscodeSetting = "MyIDPasscodeSetting"
let kTouchIDSetting = "MyIDTouchIDSetting"
let kHealthKitSetting = "MyIDHealthKitSetting"
let kHealthKitProfile = "MyIDHealthKitProfile"
let kNavigationBarItemColor = UIColor(red: 51.0 / 255, green: 51.0 / 255, blue: 51.0 / 255, alpha: 1.0)
let kNetworkError = "Network connection error"
let kDefaultProfileImageName = "default_avatar_rect"
// Key chain
let kKeychainAccessToken = "AppName_AccessToken"
let kKeyChainPassword = "AppName_Password"
let kKeychainUserName = "AppName_UserName"
let kKeyChainUserId = "AppName_UserId"
let kDidUpdatedProfieNotificationName = "didUpdatedProfileNotificationName"
// Constants for API
let kOAuthPath = "/auth/sign_in"
let kAPIRegisterMobile = "/user/mobile"
let kAPILogin = "/user/login"
let kAPILogout = "/user/logout"
let kAPIRegister = "/user/registration"
let kAPIGetOauthToken = "/oauth/token"
let kAPIGetProfile = "/user"
let kAPIUpdateProfile = "/user/profile"
let kAPIChangePassword = "/user/resetPassword"
let kAPIForgotPassword = "/user/forgotPassword"
let kAPIResetPassword = "/reset/password"
// Constants for string format
let kInputDateFormat = "MM-dd-yyyy HH:mm"
let kInputBookDateFormat = "MM-dd-yyyy h:mm a"
let kOutputDateFormat = "MMMM dd h:mma"
let kOutputBookDateFormat = "MMMM dd, yyyy"
// Constants for json keys in response message returned by Invoking API
let kResultKey = "result"
let kMessageCodeKey = "message_code"
let kSuccessResult = "success"
let kAccessToken = "authentication_token"
let kRefreshAccessToken = "refresh_token"
// Constants for oauth api
let kClientId = "9e6ffb04-91ab-4d3f-92b2-c31d8e6aebd4"
let kClientSecret = "57cc7420-4709-478b-85b2-f9221464c614"
let kGrantType = "password"
let kSqliteName = "iOSAppName.sqlite"
// Splash constants
let kDefaultTimeToLiveSplash = 3.0// unit: seconds

let kTimerIntervalSplash = 0.5// unit: seconds

// Notifications
let kLoginSuccessed = "Login Successed"
let kLoginFailed = "Login Failed"
let kApplicationLoadFinished = "Application load finished"
// Refresh token interval
let kRefreshTokenInterval = 10 * 60
let kRefreshDataInterval = 60
// Storyboard file name
let kMainStoryboardName_iPad = ""
let kMainStoryboardName_iPhone = ""
// Security storyboard
let kSecurityStoreyboard = "Security"
let kSignInViewControllerId = "LogInViewController"
let kMainStoreyboard = "Main"
let kHomeViewControllerId = "HomeViewController"