//
//  TSDRequest.h
//  TechStartUpDeveloper
//
//  Created by Dev on 14/04/2014.
//  Copyright (c) 2014 TechStartUpDeveloper. All rights reserved.
import Foundation
class YDRequest: NSObject {
    convenience override init(request req: NSURLRequest) {
        super.init()
        if self != nil {
            request = req
        }
    }

    convenience override init(URL url: NSURL, withJSONDict jsonDict: [NSObject : AnyObject]) {
        var error: NSError
        var jsonData: NSData = NSJSONSerialization.dataWithJSONObject(jsonDict, options: NSJSONWritingPrettyPrinted, error: error)
        var stringJSON: String = String(data: jsonData, encoding: NSUTF8StringEncoding)
        var req: NSMutableURLRequest = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestReloadIgnoringLocalCacheData, timeoutInterval: 60)
        //import to the the Content-Type to application/json to receive JSON format response
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.HTTPMethod = "POST"
        var msgLength: String = "\(UInt(stringJSON.characters.count))"
        req.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.HTTPBody = stringJSON.dataUsingEncoding(NSUTF8StringEncoding)
        return self(request: req)
    }

    func startWithCompletion(compl: (request: YDRequest, data: NSData, success: Bool) -> Void) {
        completion = compl.copy()
        connection = NSURLConnection(request: request, delegate: self)
        if connection != nil {
            webData =
            NSMutableData.data()retain]
            webData = NSMutableData()
        }
        else {
            completion(self, nil, false)
        }
    }

    convenience override init(URLEncodedForSMS url: NSURL, withJSONDict jsonDict: [NSObject : AnyObject]) {
        var urlEncodedData: NSMutableString = NSMutableString()
        if jsonDict != nil && jsonDict.count > 0 {
            var first: Bool = true
            for key: String in jsonDict {
                if !first {
                    urlEncodedData.appendString("&")
                }
                first = false
                urlEncodedData.appendString(self.urlencode(key))
                urlEncodedData.appendString("=")
                urlEncodedData.appendString(self.urlencode(jsonDict[key]))
            }
        }
            //NSURL *url = [NSURL URLWithString:url_str];
        var req: NSMutableURLRequest = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestReloadIgnoringLocalCacheData, timeoutInterval: 60)
        req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        req.HTTPMethod = "POST"
            //[req setHTTPShouldHandleCookies:NO];
            //[req setValue:@"Agent name goes here" forHTTPHeaderField:@"User-Agent"];
        var msgLength: String = "\(UInt(urlEncodedData.characters.count))"
        req.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        req.HTTPBody = urlEncodedData.dataUsingEncoding(NSUTF8StringEncoding)
        return self(request: req)
    }

    convenience override init(URLForUploadImage url: NSURL, withJSONDict jsonDict: [NSObject : AnyObject], withImageData imageData: NSData) {
        var timeStamp: NSTimeInterval = NSDate().timeIntervalSince1970
        var timeStampObj: Int = Int(timeStamp)
        var file: String? = nil
        file = "PICT_\(timeStampObj.stringValue()).png"
            //NSString *urlString=[NSString stringWithFormat:@"%@?%@",CSUploadFileApiURL,strHttpBody];
        var req: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        //[req setCachePolicy:NSURLRequestUseProtocolCachePolicy];
        //[req setTimeoutInterval:CSSUserServiceApiTimeOutInterval];
        req.HTTPMethod = "POST"
        req.addValue("mobile", forHTTPHeaderField: "source")
            //[request setHTTPBody:[strHttpBody dataUsingEncoding:NSUTF8StringEncoding]];
        var boundary: String = "---------------------------14737809831466499882746641449"
        var contentType: String = "multipart/form-data; boundary=\(boundary)"
        req.addValue(contentType, forHTTPHeaderField: "Content-Type")
        var body: NSMutableData = NSMutableData.data()
        //Append id data in body
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding))
        body.appendData(String(format: "Content-Disposition: form-data; name=\"user_id\"\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding))
        body.appendData("\(jsonDict["user_id"] as! String)\r\n".dataUsingEncoding(NSUTF8StringEncoding))
        //Append image data in body
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding))
        body.appendData("Content-Disposition: form-data; name=\"\("file_data[0]")\"; file=\"\(file!)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding))
        body.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding))
        body.appendData(imageData)
        body.appendData(String(format: "\r\n").dataUsingEncoding(NSUTF8StringEncoding))
        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding))
            // set the content-length
        var postLength: String = "\(UInt(body.characters.count))"
        req.setValue(postLength, forHTTPHeaderField: "Content-Length")
        req.HTTPBody = body
        return self(request: req)
    }

    convenience override init(URLForGetPlacesByGoogleApi url: NSURL) {
        var req: NSMutableURLRequest = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestReloadIgnoringLocalCacheData, timeoutInterval: 60)
        //import to the the Content-Type to application/json to receive JSON format response
        //[req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        req.HTTPMethod = "GET"
        //NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[stringJSON length]];
        //[req addValue: msgLength forHTTPHeaderField:@"Content-Length"];
        //[req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        //[req setHTTPBody: [stringJSON dataUsingEncoding:NSUTF8StringEncoding]];
        return self(request: req)
    }

    func urlencode(input: String) -> String {
        let input_c: Character = input.cStringUsingEncoding(NSUTF8StringEncoding)
        var result: NSMutableString = NSMutableString()
        for var i = 0, len = strlen(input_c); i < len; i++ {
            var c: UInt8 = input_c[i]
            if (c >= "0" && c <= "9") || (c >= "A" && c <= "Z") || (c >= "a" && c <= "z") || c == "-" || c == "." || c == "_" || c == "~" {
                result.appendFormat("%c", c)
            }
            else {
                result.appendFormat("%%%02X", c)
            }
        }
        return result
    }

    func dealloc() {
        if webData != nil {
            webData
        }
        if connection != nil {
            connection
        }
        super.dealloc()
    }

    func connectionDidFinishLoading(connection: NSURLConnection) {
        completion(self, webData, httpStatusCode == 200 || httpStatusCode == 201)
    }

    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        var httpResponse: NSHTTPURLResponse = (response as! NSHTTPURLResponse)
        httpStatusCode = httpResponse.statusCode()
        webData.length = 0
    }

    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        webData.appendData(data)
    }

    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        completion(self, webData, false)
    }
    var request: NSURLRequest
    var connection: NSURLConnection
    var webData: NSMutableData
    var httpStatusCode: Int
    var completion: Void

}
//
//  TSDRequest.m
//  TechStartUpDeveloper
//
//  Created by Dev on 14/04/2014.
//  Copyright (c) 2014 TechStartUpDeveloper. All rights reserved.