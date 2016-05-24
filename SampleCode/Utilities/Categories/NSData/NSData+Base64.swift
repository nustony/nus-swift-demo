//
//  NSData+Base64.h
//  base64
//
//  Created by Matt Gallagher on 2009/06/03.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software. Permission is granted to anyone to
//  use this software for any purpose, including commercial applications, and to
//  alter it and redistribute it freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source
//     distribution.
//
import Foundation
var NewBase64Decode

var NewBase64Encode: Character

extension NSData {
    class func dataFromBase64String(aString: String) -> NSData {
        var data: NSData = aString.dataUsingEncoding(NSASCIIStringEncoding)
            var outputLength: size_t
        var outputBuffer = NewBase64Decode(data.bytes(), data.characters.count, outputLength)
        var result: NSData = NSData.dataWithBytes(outputBuffer, length: outputLength)
        free(outputBuffer)
        return result
    }

    func base64EncodedString() -> String {
            var outputLength: size_t
        var outputBuffer: Character = NewBase64Encode(self.bytes(), self.characters.count, true, outputLength)
        var result: String = String(bytes: outputBuffer, length: outputLength, encoding: NSASCIIStringEncoding)
        free(outputBuffer)
        return result
    }

    //
    // dataFromBase64String:
    //
    // Creates an NSData object containing the base64 decoded representation of
    // the base64 string 'aString'
    //
    // Parameters:
    //    aString - the base64 string to decode
    //
    // returns the autoreleased NSData representation of the base64 string
    //
    //
    // base64EncodedString
    //
    // Creates an NSString object that contains the base 64 encoding of the
    // receiver's data. Lines are broken at 64 characters long.
    //
    // returns an autoreleased NSString being the base 64 representation of the
    //	receiver.
    //
}
//
//  NSData+Base64.m
//  base64
//
//  Created by Matt Gallagher on 2009/06/03.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software. Permission is granted to anyone to
//  use this software for any purpose, including commercial applications, and to
//  alter it and redistribute it freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source
//     distribution.
//

//
// Mapping from 6 bit pattern to ASCII character.
//
var base64EncodeLookup: UInt8 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

//
// Definition for "masked-out" areas of the base64DecodeLookup mapping
//
let xx = 65
//
// Mapping from ASCII character to 6 bit pattern.
//
var base64DecodeLookup: UInt8 = UInt8()
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.62
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.63
    base64DecodeLookup.52
    base64DecodeLookup.53
    base64DecodeLookup.54
    base64DecodeLookup.55
    base64DecodeLookup.56
    base64DecodeLookup.57
    base64DecodeLookup.58
    base64DecodeLookup.59
    base64DecodeLookup.60
    base64DecodeLookup.61
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.0
    base64DecodeLookup.1
    base64DecodeLookup.2
    base64DecodeLookup.3
    base64DecodeLookup.4
    base64DecodeLookup.5
    base64DecodeLookup.6
    base64DecodeLookup.7
    base64DecodeLookup.8
    base64DecodeLookup.9
    base64DecodeLookup.10
    base64DecodeLookup.11
    base64DecodeLookup.12
    base64DecodeLookup.13
    base64DecodeLookup.14
    base64DecodeLookup.15
    base64DecodeLookup.16
    base64DecodeLookup.17
    base64DecodeLookup.18
    base64DecodeLookup.19
    base64DecodeLookup.20
    base64DecodeLookup.21
    base64DecodeLookup.22
    base64DecodeLookup.23
    base64DecodeLookup.24
    base64DecodeLookup.25
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.26
    base64DecodeLookup.27
    base64DecodeLookup.28
    base64DecodeLookup.29
    base64DecodeLookup.30
    base64DecodeLookup.31
    base64DecodeLookup.32
    base64DecodeLookup.33
    base64DecodeLookup.34
    base64DecodeLookup.35
    base64DecodeLookup.36
    base64DecodeLookup.37
    base64DecodeLookup.38
    base64DecodeLookup.39
    base64DecodeLookup.40
    base64DecodeLookup.41
    base64DecodeLookup.42
    base64DecodeLookup.43
    base64DecodeLookup.44
    base64DecodeLookup.45
    base64DecodeLookup.46
    base64DecodeLookup.47
    base64DecodeLookup.48
    base64DecodeLookup.49
    base64DecodeLookup.50
    base64DecodeLookup.51
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx
    base64DecodeLookup.xx

//
// Fundamental sizes of the binary and base64 encode/decode units in bytes
//
let BINARY_UNIT_SIZE = 3
let BASE64_UNIT_SIZE = 4
//
// NewBase64Decode
//
// Decodes the base64 ASCII string in the inputBuffer to a newly malloced
// output buffer.
//
//  inputBuffer - the source ASCII string for the decode
//	length - the length of the string or -1 (to specify strlen should be used)
//	outputLength - if not-NULL, on output will contain the decoded length
//
// returns the decoded buffer. Must be free'd by caller. Length is given by
//	outputLength.
//
func NewBase64Decode(outputLength) {
    if length == -1 {
        length = strlen(inputBuffer)
    }
    var outputBufferSize: size_t = ((length + BASE64_UNIT_SIZE - 1) / BASE64_UNIT_SIZE) * BINARY_UNIT_SIZE
    var outputBuffer: UInt8 = UInt8(malloc(outputBufferSize))
    var i: size_t = 0
    var j: size_t = 0
    while i < length {
            //
            // Accumulate 4 valid characters (ignore everything else)
            //
        var accumulated: UInt8
        var accumulateIndex: size_t = 0
        while i < length {
            var decode: UInt8 = base64DecodeLookup[inputBuffer[i++]]
            if decode != xx {
                accumulated[accumulateIndex] = decode
                accumulateIndex++
                if accumulateIndex == BASE64_UNIT_SIZE {

                }
            }
        }
        //
        // Store the 6 bits from each of the 4 characters as 3 bytes
        //
        // (Uses improved bounds checking suggested by Alexandre Colucci)
        //
        if accumulateIndex >= 2 {
            outputBuffer[j] = (accumulated[0] << 2) | (accumulated[1] >> 4)
        }
        if accumulateIndex >= 3 {
            outputBuffer[j + 1] = (accumulated[1] << 4) | (accumulated[2] >> 2)
        }
        if accumulateIndex >= 4 {
            outputBuffer[j + 2] = (accumulated[2] << 6) | accumulated[3]
        }
        j += accumulateIndex - 1
    }
    if outputLength {
        outputLength = j
    }
    return outputBuffer
}

//
// NewBase64Encode
//
// Encodes the arbitrary data in the inputBuffer as base64 into a newly malloced
// output buffer.
//
//  inputBuffer - the source data for the encode
//	length - the length of the input in bytes
//  separateLines - if zero, no CR/LF characters will be added. Otherwise
//		a CR/LF pair will be added every 64 encoded chars.
//	outputLength - if not-NULL, on output will contain the encoded length
//		(not including terminating 0 char)
//
// returns the encoded buffer. Must be free'd by caller. Length is given by
//	outputLength.
//
func () -> Character {
    let buffer
    let size_t
    let bool
    let size_t
    outputLength)
    {
        let inputBuffer: UInt8 = UInt8(buffer)
    }
}

let MAX_NUM_PADDING_CHARS = 2
let OUTPUT_LINE_LENGTH = 64
let INPUT_LINE_LENGTH = ((OUTPUT_LINE_LENGTH / BASE64_UNIT_SIZE) * BINARY_UNIT_SIZE)
let CR_LF_SIZE = 2
//
// Byte accurate calculation of final buffer size
//
var outputBufferSize: size_t = ((length / BINARY_UNIT_SIZE) + ((length % BINARY_UNIT_SIZE) ? 1 : 0)) * BASE64_UNIT_SIZE

func () {
    outputBufferSize += (outputBufferSize / OUTPUT_LINE_LENGTH) * CR_LF_SIZE
}

//
// Include space for a terminating zero
//
//
// Allocate the output buffer
//
var outputBuffer: Character = Character(malloc(outputBufferSize))

func () {
    (!outputBuffer)
    {
        return nil
    }
    var i: size_t = 0
    var j: size_t = 0
    let lineLength: size_t = separateLines ? INPUT_LINE_LENGTH : length
    var lineEnd: size_t = lineLength
    while true {
        if lineEnd > length {
            lineEnd = length
        }
        for ; i + BINARY_UNIT_SIZE - 1 < lineEnd; i += BINARY_UNIT_SIZE {
            outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i] & 0xFC) >> 2]
            outputBuffer[j++] = base64EncodeLookup[((inputBuffer[i] & 0x03) << 4) | ((inputBuffer[i + 1] & 0xF0) >> 4)]
            outputBuffer[j++] = base64EncodeLookup[((inputBuffer[i + 1] & 0x0F) << 2) | ((inputBuffer[i + 2] & 0xC0) >> 6)]
            outputBuffer[j++] = base64EncodeLookup[inputBuffer[i + 2] & 0x3F]
        }
        if lineEnd == length {

        }
        outputBuffer[j++] = "\r"
        outputBuffer[j++] = "\n"
        lineEnd += lineLength
    }
    if i + 1 < length {
        outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i] & 0xFC) >> 2]
        outputBuffer[j++] = base64EncodeLookup[((inputBuffer[i] & 0x03) << 4) | ((inputBuffer[i + 1] & 0xF0) >> 4)]
        outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i + 1] & 0x0F) << 2]
        outputBuffer[j++] = "="
    }
    else if i < length {
        outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i] & 0xFC) >> 2]
        outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i] & 0x03) << 4]
        outputBuffer[j++] = "="
        outputBuffer[j++] = "="
    }

    outputBuffer[j] = 0
    if outputLength {
        outputLength = j
    }
    return outputBuffer
}