//
//  NSString+CCCryptUtil.h
//  Goal
//
//  Created by NUS Technology on 9/18/14.
//
//
import Foundation
extension NSString {
    class func AES256Encrypt(strSource: String, withKey key: String) -> NSData {
        var dataSource: NSData = strSource.dataUsingEncoding(NSUTF8StringEncoding)
        return dataSource.AES256EncryptWithKey(key.MD5())
    }

    class func AES256Decrypt(dataSource: NSData, withKey key: String) -> String {
        var decryptData: NSData = dataSource.AES256DecryptWithKey(key.MD5())
        return String(data: decryptData, encoding: NSUTF8StringEncoding)
    }

    // md5
    
}
//
//  NSString+CCCryptUtil.m
//  Goal
//
//  Created by NUS Technology on 9/18/14.
//
//