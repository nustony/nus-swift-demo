//
//  Macros.h
//
//  Created by NUS Technology on 8/21/14.
//  Copyright (c) 2014 Sample Code, LLC. All rights reserved.
//

let APP_VERSION = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion")
let APP_NAME = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName")
let APP_DELEGATE = ((UIApplication.sharedApplication().delegate as! AppDelegate))
let USER_DEFAULTS = NSUserDefaults.standardUserDefaults()
let APPLICATION = UIApplication.sharedApplication()
let BUNDLE = NSBundle.mainBundle()
let MAIN_SCREEN = UIScreen.mainScreen()
let DOCUMENTS_DIR = NSFileManager.defaultManager().URLsForDirectory(NSDocumentDirectory, inDomains: NSUserDomainMask).lastObject()
let NAV_BAR = self.navigationController.navigationBar
let TAB_BAR = self.tabBarController.tabBar
let DATE_COMPONENTS = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
let IS_PAD = (UI_USER_INTERFACE_IDIOM() == .Pad)
let IS_IPHONE_5 = (fabs(Double(UIScreen.mainScreen().bounds.size.height) - Double(568)) < DBL_EPSILON)
// Props
let ScreenWidth = MAIN_SCREEN.bounds.size.width
let ScreenHeight = MAIN_SCREEN.bounds.size.height
let NavBarHeight = self.navigationController.navigationBar.bounds.size.height
let TabBarHeight = self.tabBarController.tabBar.bounds.size.height
let StatusBarHeight = UIApplication.sharedApplication().statusBarFrame().size.height
let SelfBoundsWidth = self.bounds.size.width
let SelfBoundsHeight = self.bounds.size.height
let SelfFrameWidth = self.frame.size.width
let SelfFrameHeight = self.frame.size.height
let SelfViewBoundsWidth = self.view.bounds.size.width
let SelfViewBoundsHeight = self.view.bounds.size.height
let SelfViewFrameWidth = self.view.frame.size.width
let SelfViewFrameHeight = self.view.frame.size.height
let SelfX = self.frame.origin.x
let SelfY = self.frame.origin.y
let SelfViewX = self.view.frame.origin.x
let SelfViewY = self.view.frame.origin.y
// Utils
//#define clamp(n,min,max)                        ((n < min) ? min : (n > max) ? max : n)
//#define distance(a,b)                           sqrtf((a-b) * (a-b))
//#define point(x,y)                              CGPointMake(x, y)
//#define append(a,b)                             [a stringByAppendingString:b];
//#define stripNSNull(a)                          (a && [a isKindOfClass:[NSNull class]]) ? nil : a
//#define stringNotNilOrEmpty(a)                  (a && [a isKindOfClass:[NSString class]] && [a length] > 0)
//#define stripNilAndEmpty(a)                     (a && [a isKindOfClass:[NSString class]] && [a length] > 0) ? a : nil;
// Colors
//#define hex_rgba(c)                             [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0]
//#define hex_rgb(c)                              [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:((c)&0xFF)/255.0 alpha:1.0]
// Views Getters
//#define frameWidth(v)                           v.frame.size.width
//#define frameHeight(v)                          v.frame.size.height
//#define boundsWidth(v)                          v.bounds.size.width
//#define boundsHeight(v)                         v.bounds.size.height
//#define posX(v)                                 v.frame.origin.x
//#define posY(v)                                 v.frame.origin.y
//#define rightEdgePosition(v)                    (v.frame.origin.x + v.frame.size.width)
//#define bottomEdgePosition(v)                   (v.frame.origin.y + v.frame.size.height)
// View Setters
//#define setPosX(v,x)                            v.frame = CGRectMake(x, posY(v), frameWidth(v), frameHeight(v))
//#define setPosY(v,y)                            v.frame = CGRectMake(posX(v), y, frameWidth(v), frameHeight(v))
//#define setFramePosition(v,x,y)                 v.frame = CGRectMake(x, y, frameWidth(v), frameHeight(v))
//#define setFrameSize(v,w,h)                     v.frame = CGRectMake(posX(v), posY(v), w, h)
//#define setBoundsPosition(v,x,y)                v.bounds = CGRectMake(x, y, boundsWidth(v), boundsHeight(v))
//#define setBoundsSize(v,w,h)                    v.bounds = CGRectMake(posX(v), posY(v), w, h)
// View Transformations
//#define rotate(v,r)                             v.transform = CGAffineTransformMakeRotation(r / 180.0 * M_PI)
//#define scale(v,sx,sy)                          v.transform = CGAffineTransformMakeScale(sx, sy)
//#define animate(dur,curve,anims)                [UIView beginAnimations:nil context:NULL]; [UIView setAnimationDuration:dur]; [UIView setAnimationCurve:curve]; anims; [UIView commitAnimations]
// Notifications
//#define addEventListener(id,s,n,o)              [[NSNotificationCenter defaultCenter] addObserver:id selector:s name:n object:o]
//#define removeEventListener(id,n,o)             [[NSNotificationCenter defaultCenter] removeObserver:id name:n object:o]
//#define dispatchEvent(n,o)                      [[NSNotificationCenter defaultCenter] postNotificationName:n object:o]
//#define dispatchEventWithData(n,o,d)            [[NSNotificationCenter defaultCenter] postNotificationName:n object:o userInfo:d]
// User Defaults
//#define boolForKey(k)                           [USER_DEFAULTS boolForKey:k]
//#define floatForKey(k)                          [USER_DEFAULTS floatForKey:k]
//#define integerForKey(k)                        [USER_DEFAULTS integerForKey:k]
//#define objectForKey(k)                         [USER_DEFAULTS objectForKey:k]
//#define doubleForKey(k)                         [USER_DEFAULTS doubleForKey:k]
//#define urlForKey(k)                            [USER_DEFAULTS urlForKey:k]
//#define setBoolForKey(v, k)                     [USER_DEFAULTS setBool:v forKey:k]
//#define setFloatForKey(v, k)                    [USER_DEFAULTS setFloat:v forKey:k]
//#define setIntegerForKey(v, k)                  [USER_DEFAULTS setInteger:v forKey:k]
//#define setObjectForKey(v, k)                   [USER_DEFAULTS setObject:v forKey:k];
//#define setDoubleForKey(v, k)                   [USER_DEFAULTS setDouble:v forKey:k]
//#define setURLForKey(v, k)                      [USER_DEFAULTS setURL:v forKey:k]
// radians and degrees
//#define radiansToDegrees(radians) ((radians) * (180.0 / M_PI))
//#define degreesToRadians(angle) ((angle) / 180.0 * M_PI)
// NSLog only in debug mode
func DLog() {
    "%s [Line %d] "
}

func () {
}

// Show alert
//#define alert(title,body,buttontitle)               [[[[UIAlertView alloc] initWithTitle:title message:body delegate:nil cancelButtonTitle:buttontitle otherButtonTitles:nil] autorelease] show]
// Fonts
//#define font(sz)                             [UIFont fontWithName:@"HelveticaNeue" size:sz]
//#define fontBold(sz)                         [UIFont fontWithName:@"HelveticaNeue-Bold" size:sz]
//#define fontItalic(sz)                       [UIFont fontWithName:@"HelveticaNeue-Italic" size:sz]
let fontSizeTitle = IS_PAD ? 32 : 21
let fontSizeSubtitle = IS_PAD ? 15 : 13
let fontSizeText = IS_PAD ? 17 : 15
let fontTitle = fontBold(fontSizeTitle)
let fontSubtitle = fontItalic(fontSizeSubtitle)
let fontText = font(fontSizeText)
let fontColorTitle = "#FFFFFF"
let fontColorSubtitle = "AAAAAA"
let fontColorText = "FFFFFF"
//#define SAFE_BRIDGE_NSSTRING(x)             ((__bridge NSString*)(x) ? (__bridge_transfer NSString*)(x) : @"")