//
//  NSString+MD5.h
//  MyPersonalLibrary
//  This file is part of source code lessons that are related to the book
//  Title: Professional IOS Programming
//  Publisher: John Wiley & Sons Inc
//  ISBN 978-1-118-66113-0
//  Author: Dev
//  Company: YourDeveloper Mobile Solutions
//  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
//  Copyright (c) 2013 with the author and publisher. All rights reserved.
//
import Foundation
extension NSString {
    func MD5() -> String {
            // Create pointer to the string as UTF8
        let ptr: Character = self.UTF8String()
            // Create byte array of unsigned chars
        var md5Buffer: UInt8
        // Create 16 bytes MD5 hash value, store in buffer
        CC_MD5(ptr, (strlen(ptr) as! CC_LONG), md5Buffer)
            // Convert unsigned char buffer to NSString of hex values
        var output: NSMutableString = NSMutableString(capacity: CC_MD5_DIGEST_LENGTH * 2)
        for var i = 0; i < CC_MD5_DIGEST_LENGTH; i++ {
            output.appendFormat("%02x", md5Buffer[i])
        }
        return output
    }
}
//
//  NSString+MD5.m
//  MyPersonalLibrary
//  This file is part of source code lessons that are related to the book
//  Title: Professional IOS Programming
//  Publisher: John Wiley & Sons Inc
//  ISBN 978-1-118-66113-0
//  Author: Dev
//  Company: YourDeveloper Mobile Solutions
//  Contact the author: www.yourdeveloper.net | info@yourdeveloper.net
//  Copyright (c) 2013 with the author and publisher. All rights reserved.
//

import CommonCrypto