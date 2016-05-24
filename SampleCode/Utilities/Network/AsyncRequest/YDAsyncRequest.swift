//
//  YDAsyncRequest.h
//  GCDDownloader
//
//  Created by Dev on 03/09/2013.
//  Copyright (c) 2013 Dev. All rights reserved.
//
import Foundation
protocol YDAsyncRequestDelegate: NSObject {
    func requestDidFinish()

    func requestDidFail()
}
class YDAsyncRequest: NSObject {
    var requestDidFinishSelector: Selector
    var requestDidFailSelector: Selector

    //constructor
    convenience override init(requestWithURL url: NSURL) {
        if (super.init()) {
            self.reqURL = url
        }
    }
    //public properties
    weak var delegate: YDAsyncRequestDelegate
    var DownloadDestinationPath: String
    var requestDidFinishSelector: Selector
    var requestDidFailSelector: Selector
    //public methods

    func startRequest() {
        //create filestream
        self.fileStream = NSOutputStream.outputStreamToFileAtPath(self.DownloadDestinationPath, append: false)
        //open the stream
        self.fileStream.open()
            // create the request
        var request: NSURLRequest = NSURLRequest(URL: self.reqURL)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler: {(response: NSURLResponse, data: NSData, error: NSError) -> Void in
            if data.characters.count > 0 && error == nil {
                    var dataLength: Int
                let dataBytes: UInt8
                    var bytesWritten: Int
                    var bytesWrittenSoFar: Int
                dataLength = data.characters.count
                dataBytes = data.bytes()
                bytesWrittenSoFar = 0
                repeat {
                    bytesWritten = self.fileStream.write(dataBytes[bytesWrittenSoFar], maxLength: dataLength - bytesWrittenSoFar)
                    if bytesWritten == -1 {
                        self.requestFailed()
                    }
                    else {
                        bytesWrittenSoFar += bytesWritten
                    }
                    bytesDownloaded += bytesWritten
                } while bytesWrittenSoFar != dataLength
                self.requestFinished()
            }
            else if data.characters.count == 0 && error == nil {
                self.requestFinished()
            }
            else if error != nil {
                self.requestFailed()
            }

        })
    }

    func shutDownConnectionAndStream() {
        // Shuts down the connection and stream
        if self.connection != nil {
            self.connection.cancel()
            self.connection = nil
        }
        if self.fileStream != nil {
            self.fileStream.close()
            self.fileStream = nil
        }
    }

    func connection(conn: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        var httpResponse: NSHTTPURLResponse
        httpResponse = (response as! NSHTTPURLResponse)
        //read the content length from the header field
        fileSize = CInteger(httpResponse.allHeaderFields()["Content-Length"])!
        bytesDownloaded = 0
        //check the status code
        if httpResponse.statusCode != 200 {
            self.requestFailed()
        }
    }

    func connection(conn: NSURLConnection, didReceiveData data: NSData) {
        // delegate called by the NSURLConnection as data arrives.
        // just write the data to the file.
            //you need some variable to keep track on where you are writing bytes coming in over the data stream
            var dataLength: Int
        let dataBytes: UInt8
            var bytesWritten: Int
            var bytesWrittenSoFar: Int
        dataLength = data.characters.count
        dataBytes = data.bytes()
        bytesWrittenSoFar = 0
        repeat {
            bytesWritten = self.fileStream.write(dataBytes[bytesWrittenSoFar], maxLength: dataLength - bytesWrittenSoFar)
            if bytesWritten == -1 {
                self.requestFailed()
            }
            else {
                bytesWrittenSoFar += bytesWritten
            }
            bytesDownloaded += bytesWritten
        } while bytesWrittenSoFar != dataLength
    }

    func connection(conn: NSURLConnection, didFailWithError error: NSError) {
        self.requestFailed()
    }

    func connectionDidFinishLoading(conn: NSURLConnection) {
        self.requestFinished()
    }
    //private methods

    func requestFinished() {
        self.shutDownConnectionAndStream()
        if self.requestDidFinishSelector() {
            SuppressPerformSelectorLeakWarning(self.delegate.performSelector(self.requestDidFinishSelector(), withObject: self))
        }
        //call delegate
        if self.delegate.respondsToSelector("requestDidFinish") {
            self.delegate.requestDidFinish()
        }
    }

    func requestFailed() {
        self.shutDownConnectionAndStream()
        if self.requestDidFailSelector() {
            SuppressPerformSelectorLeakWarning(self.delegate.performSelector(self.requestDidFailSelector(), withObject: self))
        }
        //call delegate
        if self.delegate.respondsToSelector("requestDidFail") {
            self.delegate.requestDidFail()
        }
    }
    var fileSize: Int
    var bytesDownloaded: Int
    var data_: NSMutableData


    var reqURL: NSURL
    var fileStream: NSOutputStream
    var isReceiving: Bool {
        get {
            return self.isReceiving
        }
    }

    var connection: NSURLConnection {
        get {
            var httpResponse: NSHTTPURLResponse
            httpResponse = (response as! NSHTTPURLResponse)
            //read the content length from the header field
            fileSize = CInteger(httpResponse.allHeaderFields()["Content-Length"])!
            bytesDownloaded = 0
            //check the status code
            if httpResponse.statusCode != 200 {
                self.requestFailed()
            }
        }
    }
}
//
//  YDAsyncRequest.m
//  GCDDownloader
//
//  Created by Dev on 03/09/2013.
//  Copyright (c) 2013 Dev. All rights reserved.
//

//#define SuppressPerformSelectorLeakWarning(Stuff) \
func () {
    ("clang diagnostic push")\
    Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
    Pragma("clang diagnostic pop")\
}

func () {
    (0)
}