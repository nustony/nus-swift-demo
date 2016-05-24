//
//  NSData+CCCryptUtil.h
//  Goal
//
//  Created by NUS Technology on 9/18/14.
//
//
import Foundation
import CommonCrypto
extension NSData {
    func AES256EncryptWithKey(key: String) -> NSData {
        var keyPtr: Character
        // room for terminator (unused)
        bzero(keyPtr, sizeof())
        // fill with zeroes (for padding)
        key.getCString(keyPtr, maxLength: sizeof(), encoding: NSUTF8StringEncoding)
        var dataLength: Int = self.characters.count
        var bufferSize: size_t = dataLength + kCCBlockSizeAES128
        var buffer = malloc(bufferSize)
        var numBytesEncrypted: size_t = 0
        var cryptStatus: CCCryptorStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, keyPtr, kCCKeySizeAES256, nil,             /* initialization vector (optional) */
, self.bytes(), dataLength,             /* input */
buffer, bufferSize,             /* output */
numBytesEncrypted)
        if cryptStatus == kCCSuccess {
            return NSData.dataWithBytesNoCopy(buffer, length: numBytesEncrypted)
        }
        free(buffer)
        return nil
    }

    func AES256DecryptWithKey(key: String) -> NSData {
        var keyPtr: Character
        // room for terminator (unused)
        bzero(keyPtr, sizeof())
        // fill with zeroes (for padding)
        // fetch key data
        key.getCString(keyPtr, maxLength: sizeof(), encoding: NSUTF8StringEncoding)
        var dataLength: Int = self.characters.count
        var bufferSize: size_t = dataLength + kCCBlockSizeAES128
        var buffer = malloc(bufferSize)
        var numBytesDecrypted: size_t = 0
        var cryptStatus: CCCryptorStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, keyPtr, kCCKeySizeAES256, nil,             /* initialization vector (optional) */
, self.bytes(), dataLength,             /* input */
buffer, bufferSize,             /* output */
numBytesDecrypted)
        if cryptStatus == kCCSuccess {
            return NSData.dataWithBytesNoCopy(buffer, length: numBytesDecrypted)
        }
        free(buffer)
        //free the buffer;
        return nil
    }
}
//
//  NSData+CCCryptUtil.m
//  Goal
//
//  Created by NUS Technology on 9/18/14.
//
//