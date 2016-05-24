//
//  NUS TechnologyLocalizations.h
//
//  Created by NUS Technology on 4/25/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//
import Foundation
//#define LOCALIZATION(text) [[Localizations sharedInstance] localizedStringForKey:(text)]
let CURRENT_LANGUAGE = Localizations.sharedInstance().getCurrentLanguage()
let ENGLISH = "en"
let DEFAULT = "Default"
let notificationLanguageChanged: String = "notificationLanguageChanged"

class Localizations: NSObject {
    var availableLanguagesArray: [AnyObject] {
        get {
            return self.availableLanguagesArray
        }
    }

    var saveInUserDefaults: Bool {
        get {
            return ((self.defaults[saveLanguageDefaultKey] as! String) != nil)
        }
        set(saveInUserDefaults) {
            if saveInUserDefaults {
                self.defaults[saveLanguageDefaultKey] = currentLanguage
            }
            else {
                self.defaults.removeObjectForKey(saveLanguageDefaultKey)
            }
            self.defaults.synchronize()
        }
    }

    var currentLanguage: String

    class func sharedInstance() -> Localizations {
        var sharedInstance: Localizations? = nil
            var oncePredicate: dispatch_once_t
        dispatch_once(oncePredicate, {() -> Void in
            self.sharedInstance = Localizations()
        })
        return sharedInstance!
    }

    func getCurrentLanguage() -> String {
        return currentLanguage
    }

    func localizedStringForKey(key: String) -> String {
        if self.dicoLocalisation == nil {
            return NSLocalizedString(key, key)
        }
        else {
            var localizedString: String = self.dicoLocalisation[key]
            if localizedString == nil {
                localizedString = key
            }
            return localizedString
        }
    }

    func setLanguage(newLanguage: String) -> Bool {
        if newLanguage == nil || (newLanguage == self.currentLanguage) || !self.availableLanguagesArray.containsObject(newLanguage) {
            return false
        }
        if (newLanguage == DEFAULT) {
            self.currentLanguage = newLanguage.copy()
            self.dicoLocalisation = nil
            NSNotificationCenter.defaultCenter().postNotificationName(notificationLanguageChanged, object: nil)
            return true
        }
        else {
            var isLoadingOk: Bool = self.loadDictionaryForLanguage(newLanguage)
            if isLoadingOk {
                NSNotificationCenter.defaultCenter().postNotificationName(notificationLanguageChanged, object: nil)
                if self.saveInUserDefaults() {
                    self.defaults[saveLanguageDefaultKey] = currentLanguage
                    self.defaults.synchronize()
                }
            }
            return isLoadingOk
        }
    }

    convenience override init() {
        super.init()
                self.defaults = NSUserDefaults.standardUserDefaults()
            self.availableLanguagesArray = [DEFAULT, ENGLISH]
            self.dicoLocalisation = nil
            self.currentLanguage = DEFAULT
            var languageSaved: String = (defaults[saveLanguageDefaultKey] as! String)
            if languageSaved != nil && !(languageSaved == DEFAULT) {
                self.loadDictionaryForLanguage(languageSaved)
            }
    }

    func loadDictionaryForLanguage(newLanguage: String) -> Bool {
        var urlPath: NSURL = NSBundle.bundleForClass(self.self)(URLForResource: "Localizable", withExtension: "strings", subdirectory: nil, localization: newLanguage)
        if NSFileManager.defaultManager().fileExistsAtPath(urlPath.path) {
            self.currentLanguage = newLanguage.copy()
            self.dicoLocalisation = [NSObject : AnyObject](contentsOfFile: urlPath.path).copy()
            return true
        }
        return false
    }

    var dicoLocalisation: [NSObject : AnyObject]
    var defaults: NSUserDefaults
}
//
//  NUS TechnologyLocalizations.m
//
//  Created by NUS Technology on 4/25/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//

let saveLanguageDefaultKey: String = "saveLanguageDefaultKey"