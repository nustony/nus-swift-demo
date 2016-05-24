//
//  User.h
// Sample Code
//
//  Created by NUS Technology on 10/23/14.
//  Copyright (c) 2014 Sample Code, LLC. All rights reserved.
//
import Foundation
import Mantle
class User: MTLModel, MTLJSONSerializing, MTLManagedObjectSerializing {
    var identifier: String
    var email: String
    var password: String

    class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject] {
        return ["identifier": "id", "email": "email", "password": NSNull.null]
    }

    class func managedObjectEntityName() -> String {
        return User.entityName
    }

    class func managedObjectKeysByPropertyKey() -> [NSObject : AnyObject] {
        return ["identifier": "userId"]
    }

    class func propertyKeysForManagedObjectUniquing() -> Set<AnyObject> {
        return Set<AnyObject>.setWithObject("identifier")
    }

    class func passwordEntityAttributeTransformer() -> NSValueTransformer {
        return MTLValueTransformer.reversibleTransformerWithForwardBlock({(str: String) -> Void in
            return String.AES256Encrypt(str, withKey: "SampleCode")
        }, reverseBlock: {(data: NSData) -> Void in
            return String.AES256Decrypt(data, withKey: "SampleCode")
        })
    }
}
//
//  User.m
// Sample Code
//
//  Created by NUS Technology on 10/23/14.
//  Copyright (c) 2014 Sample Code, LLC. All rights reserved.
//