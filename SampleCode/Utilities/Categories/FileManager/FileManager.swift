//
//  FileManager.h
//  Sample Code
//
//  Created by NUS Technology on 9/11/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//
import Foundation
class FileManager: NSObject {
    class func saveImage(imageToSave: UIImage, toFile filePath: String) {
        var binaryImageData: NSData = UIImagePNGRepresentation(imageToSave)
        binaryImageData.writeToFile(filePath, atomically: true)
    }

    class func removeImage(fileName: String) {
        var fileManager: NSFileManager = NSFileManager.defaultManager()
        var error: NSError
        var success: Bool = fileManager.removeItemAtPath(fileName, error: error)
        if success {

        }
        else {

        }
    }

    class func generateImagePath() -> String {
        var documentsPath: String = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0]
        var imageFileName: String = FileManager.generateImageName()
        var filePath: String = documentsPath.stringByAppendingPathComponent(imageFileName)
        return filePath
    }

    class func getImagePathForFileName(fileName: String) -> String {
        var documentsPath: String = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0]
        var filePath: String = documentsPath.stringByAppendingPathComponent(fileName)
        return filePath
    }

    class func generateImageName() -> String {
        var formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss_SSS"
        var ret: String = formatter.stringFromDate(NSDate())
        return "\(ret)_\(String.generateRandomCode(3))"
    }
}
//
//  FileManager.m
//  Sample Code
//
//  Created by NUS Technology on 9/11/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//