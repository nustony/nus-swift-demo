//
//  AsyncImageView.h
//
//  Version 1.5.1
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright (c) 2011 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/AsyncImageView
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//
import UIKit
let AsyncImageLoadDidFinish: String

let AsyncImageLoadDidFail: String

let AsyncImageImageKey: String

let AsyncImageURLKey: String

let AsyncImageCacheKey: String

let AsyncImageErrorKey: String

class AsyncImageLoader: NSObject {
    class func sharedLoader() -> AsyncImageLoader {
        var sharedInstance: AsyncImageLoader? = nil
        if sharedInstance == nil {
            sharedInstance = (self as! AsyncImageLoader)()
        }
        return sharedInstance!
    }

    class func defaultCache() -> NSCache {
        var sharedCache: NSCache? = nil
        if sharedCache == nil {
            sharedCache = NSCache()
            NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationDidReceiveMemoryWarningNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {(note: __unused NSNotification) -> Void in
                sharedCache!.removeAllObjects()
            })
        }
        return sharedCache!
    }
    var cache: NSCache
    var concurrentLoads: Int
    var loadingTimeout: NSTimeInterval

    func loadImageWithURL(URL: NSURL, target: AnyObject, success: Selector, failure: Selector) {
            //check cache
        var image: UIImage = (self.cache[URL] as! UIImage)
        if image != nil {
            self.cancelLoadingImagesForTarget(self, action: success)
            if success {
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    ((objc_msgSend as! Void))(target, success, image, URL)
                })
            }
            return
        }
            //create new connection
        var connection: AsyncImageConnection = AsyncImageConnection(URL: URL, cache: self.cache, target: target, success: success, failure: failure)
        var added: Bool = false
        for var i = 0; i < self.connections.count; i++ {
            var existingConnection: AsyncImageConnection = self.connections[i]
            if !existingConnection.loading {
                self.connections.insertObject(connection, atIndex: i)
                added = true
            }
        }
        if !added {
            self.connections.append(connection)
        }
        self.updateQueue()
    }

    func loadImageWithURL(URL: NSURL, target: AnyObject, action: Selector) {
        self.loadImageWithURL(URL, target: target, success: action, failure: nil)
    }

    func loadImageWithURL(URL: NSURL) {
        self.loadImageWithURL(URL, target: nil, success: nil, failure: nil)
    }

    func cancelLoadingURL(URL: NSURL, target: AnyObject, action: Selector) {
        for var i = Int(self.connections.count) - 1; i >= 0; i-- {
            var connection: AsyncImageConnection = self.connections[Int(i)]
            if connection.URL.isEqual(URL) && connection.target == target && connection.success == action {
                connection.cancel()
                self.connections.removeAtIndex(Int(i))
            }
        }
    }

    func cancelLoadingURL(URL: NSURL, target: AnyObject) {
        for var i = Int(self.connections.count) - 1; i >= 0; i-- {
            var connection: AsyncImageConnection = self.connections[Int(i)]
            if connection.URL.isEqual(URL) && connection.target == target {
                connection.cancel()
                self.connections.removeAtIndex(Int(i))
            }
        }
    }

    func cancelLoadingURL(URL: NSURL) {
        for var i = Int(self.connections.count) - 1; i >= 0; i-- {
            var connection: AsyncImageConnection = self.connections[Int(i)]
            if connection.URL.isEqual(URL) {
                connection.cancel()
                self.connections.removeAtIndex(Int(i))
            }
        }
    }

    func cancelLoadingImagesForTarget(target: AnyObject, action: Selector) {
        for var i = Int(self.connections.count) - 1; i >= 0; i-- {
            var connection: AsyncImageConnection = self.connections[Int(i)]
            if connection.target == target && connection.success == action {
                connection.cancel()
            }
        }
    }

    func cancelLoadingImagesForTarget(target: AnyObject) {
        for var i = Int(self.connections.count) - 1; i >= 0; i-- {
            var connection: AsyncImageConnection = self.connections[Int(i)]
            if connection.target == target {
                connection.cancel()
            }
        }
    }

    func URLForTarget(target: AnyObject, action: Selector) -> NSURL {
        //return the most recent image URL assigned to the target for the given action
        //this is not neccesarily the next image that will be assigned
        for var i = Int(self.connections.count) - 1; i >= 0; i-- {
            var connection: AsyncImageConnection = self.connections[Int(i)]
            if connection.target == target && connection.success == action {
                return connection.URL
            }
        }
        return nil
    }

    func URLForTarget(target: AnyObject) -> NSURL {
        //return the most recent image URL assigned to the target
        //this is not neccesarily the next image that will be assigned
        for var i = Int(self.connections.count) - 1; i >= 0; i-- {
            var connection: AsyncImageConnection = self.connections[Int(i)]
            if connection.target == target {
                return connection.URL
            }
        }
        return nil
    }

    func init() -> AsyncImageLoader {
        if (super.init()) {
            self.cache = self.self.defaultCache()
            self.concurrentLoads = 2
            self.loadingTimeout = 60.0
            self.connections = [AnyObject]()
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "imageLoaded:", name: AsyncImageLoadDidFinish, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "imageFailed:", name: AsyncImageLoadDidFail, object: nil)
        }
    }

    func updateQueue() {
            //start connections
        var count: Int = 0
        for connection: AsyncImageConnection in self.connections {
            if !connection.isLoading() {
                if connection.isInCache() {
                    connection.start()
                }
                else if count < self.concurrentLoads {
                    count++
                    connection.start()
                }
            }
        }
    }

    func imageLoaded(notification: NSNotification) {
            //complete connections for URL
        var URL: NSURL = (notification.userInfo!)[AsyncImageURLKey]
        for var i = Int(self.connections.count) - 1; i >= 0; i-- {
            var connection: AsyncImageConnection = self.connections[Int(i)]
            if connection.URL == URL || connection.URL.isEqual(URL) {
                //cancel earlier connections for same target/action
                for var j = i - 1; j >= 0; j-- {
                    var earlier: AsyncImageConnection = self.connections[Int(j)]
                    if earlier.target == connection.target && earlier.success == connection.success {
                        earlier.cancel()
                        self.connections.removeAtIndex(Int(j))
                        i--
                    }
                }
                //cancel connection (in case it's a duplicate)
                connection.cancel()
                    //perform action
                var image: UIImage = (notification.userInfo!)[AsyncImageImageKey]
                ((objc_msgSend as! Void))(connection.target, connection.success, image, connection.URL)
                //remove from queue
                self.connections.removeAtIndex(Int(i))
            }
        }
        //update the queue
        self.updateQueue()
    }

    func imageFailed(notification: NSNotification) {
            //remove connections for URL
        var URL: NSURL = (notification.userInfo!)[AsyncImageURLKey]
        for var i = Int(self.connections.count) - 1; i >= 0; i-- {
            var connection: AsyncImageConnection = self.connections[Int(i)]
            if connection.URL.isEqual(URL) {
                //cancel connection (in case it's a duplicate)
                connection.cancel()
                //perform failure action
                if connection.failure {
                    var error: NSError = (notification.userInfo!)[AsyncImageErrorKey]
                    ((objc_msgSend as! Void))(connection.target, connection.failure, error, URL)
                }
                //remove from queue
                self.connections.removeAtIndex(Int(i))
            }
        }
        //update the queue
        self.updateQueue()
    }

    func dealloc() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    var connections: [AnyObject]
}
protocol AsyncImageViewDelegate: NSObject {
    func didLoadedImage(asyncImageView: AsyncImageView)
}
extension UIImageView {
    var imageURL: NSURL {
        get {
            return self.imageURL
        }
        set(imageURL) {
            self.isDownloadImage = true
            var image: UIImage = (AsyncImageLoader.sharedLoader().cache[imageURL] as! UIImage)
            if image != nil {
                self.image = image
                return
            }
            super.imageURL = imageURL
            if self.showActivityIndicator && !self.image && imageURL {
                if self.activityView == nil {
                    self.activityView = UIActivityIndicatorView(activityIndicatorStyle: self.activityIndicatorStyle)
                    self.activityView.hidesWhenStopped = true
                    self.activityView.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0)
                    self.activityView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleTopMargin, .FlexibleRightMargin, .FlexibleBottomMargin]
                    self.addSubview(self.activityView)
                }
                self.activityView.startAnimating()
            }
        }
    }

    func setImageURL(imageURL: NSURL) {
        AsyncImageLoader.sharedLoader().loadImageWithURL(imageURL, target: self, action: "setImage:")
    }

    func imageURL() -> NSURL {
        return AsyncImageLoader.sharedLoader()(URLForTarget: self, action: "setImage:")
    }
}
class AsyncImageView: UIImageView {
    var showActivityIndicator: Bool
    var activityIndicatorStyle: UIActivityIndicatorViewStyle {
        get {
            return self.activityIndicatorStyle
        }
        set(style) {
            self.activityIndicatorStyle = style
            self.activityView.removeFromSuperview()
            self.activityView = nil
        }
    }

    var crossfadeDuration: NSTimeInterval
    weak var delegate: protocol<NSObject, AsyncImageViewDelegate>
    var isDownloadImage: Bool

    func setUp() {
        self.showActivityIndicator = (self.image == nil)
        self.activityIndicatorStyle = .Gray
        self.crossfadeDuration = 0.4
    }

    convenience override init(frame: CGRect) {
        if (super.init(frame: frame)) {
            self.setUp()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        if (super.init(coder: aDecoder)) {
            self.setUp()
        }
    }

    func setImage(image: UIImage) {
        if image != self.image && self.crossfadeDuration {
                //jump through a few hoops to avoid QuartzCore framework dependency
            var animation: CAAnimation = NSClassFromString("CATransition")()
            animation["type"] = "kCATransitionFade"
            animation.duration = self.crossfadeDuration
            self.layer.addAnimation(animation, forKey: nil)
        }
        super.image = image
        self.activityView.stopAnimating()
        if self.delegate && self.delegate.respondsToSelector("didLoadedImage:") {
            self.delegate.didLoadedImage(self)
        }
        self.isDownloadImage = false
    }

    func dealloc() {
        AsyncImageLoader.sharedLoader().cancelLoadingURL(self.imageURL, target: self)
    }

    var activityView: UIActivityIndicatorView
}
//
//  AsyncImageView.m
//
//  Version 1.5.1
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright (c) 2011 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/AsyncImageView
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

import ObjectiveC
import QuartzCore
import Availability.h
let AsyncImageLoadDidFinish: String = "AsyncImageLoadDidFinish"

let AsyncImageLoadDidFail: String = "AsyncImageLoadDidFail"

let AsyncImageImageKey: String = "image"

let AsyncImageURLKey: String = "URL"

let AsyncImageCacheKey: String = "cache"

let AsyncImageErrorKey: String = "error"

class AsyncImageConnection: NSObject {
    var connection: NSURLConnection {
        get {
            self.data = NSMutableData.data()
        }
    }

    var data: NSMutableData
    var URL: NSURL
    var cache: NSCache
    var target: AnyObject
    var success: Selector
    var failure: Selector
    var loading: Bool
    var cancelled: Bool

    func initWithURL(URL: NSURL, cache: NSCache, target: AnyObject, success: Selector, failure: Selector) -> AsyncImageConnection {
        if (self = self()) {
            self.URL = URL
            self.cache = cache
            self.target = target
            self.success = success
            self.failure = failure
        }
    }

    func start() {
        if self.loading && !self.cancelled {
            return
        }
        //begin loading
        self.loading = true
        self.cancelled = false
        //check for nil URL
        if self.URL == nil {
            self.cacheImage(nil)
            return
        }
            //check for cached image
        var image: UIImage = self.cachedImage()
        if image != nil {
            //add to cache (cached already but it doesn't matter)
            self.performSelectorOnMainThread("cacheImage:", withObject: image, waitUntilDone: false)
            return
        }
            //begin load
        var request: NSURLRequest = NSURLRequest(URL: self.URL, cachePolicy: NSURLRequestReloadIgnoringLocalCacheData, timeoutInterval: AsyncImageLoader.sharedLoader().loadingTimeout)
        self.connection = NSURLConnection(request: request, delegate: self, startImmediately: false)
        self.connection.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        self.connection.start()
    }

    func cancel() {
        self.cancelled = true
        self.connection.cancel()
        self.connection = nil
        self.data = nil
    }

    func isInCache() -> Bool {
        return self.cachedImage() != nil
    }

    func cachedImage() -> UIImage {
        if self.URL.isFileURL() {
            var path: String = self.URL.absoluteURL().path()
            var resourcePath: String = NSBundle.mainBundle().resourcePath()
            if path.hasPrefix(resourcePath) {
                return UIImage(named: path.substringFromIndex(resourcePath.characters.count))
            }
        }
        return (self.cache[self.URL] as! String)
    }

    func loadFailedWithError(error: NSError) {
        self.loading = false
        self.cancelled = false
        NSNotificationCenter.defaultCenter().postNotificationName(AsyncImageLoadDidFail, object: self.target, userInfo: [AsyncImageURLKey: self.URL, AsyncImageErrorKey: error])
    }

    func cacheImage(image: UIImage) {
        if !self.cancelled {
            if image && self.URL {
                var storeInCache: Bool = true
                if self.URL.isFileURL() {
                    if self.URL.absoluteURL().path().hasPrefix(NSBundle.mainBundle().resourcePath()) {
                        //do not store in cache
                        storeInCache = false
                    }
                }
                if storeInCache {
                    self.cache[self.URL] = image
                }
            }
            var userInfo: [NSObject : AnyObject] = [
                    AsyncImageImageKey : image,
                    AsyncImageURLKey : self.URL
                ]

            if self.cache {
                userInfo[AsyncImageCacheKey] = self.cache
            }
            self.loading = false
            NSNotificationCenter.defaultCenter().postNotificationName(AsyncImageLoadDidFinish, object: self.target, userInfo: userInfo.copy())
        }
        else {
            self.loading = false
            self.cancelled = false
        }
    }

    func processDataInBackground(data: NSData) {
        let lockQueue = dispatch_queue_create("com.test.LockQueue")
        dispatch_sync(lockQueue) {
            if !self.cancelled {
                var image: UIImage = UIImage(data: data)!
                if image != nil {
                    //redraw to prevent deferred decompression
                    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
                    image.drawAtPoint(CGPointZero)
                    image = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    //add to cache (may be cached already but it doesn't matter)
                    self.performSelectorOnMainThread("cacheImage:", withObject: image, waitUntilDone: true)
                }
                else {
                                            var error: NSError = NSError.errorWithDomain("AsyncImageLoader", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"])
                        self.performSelectorOnMainThread("loadFailedWithError:", withObject: error, waitUntilDone: true)
                }
            }
            else {
                //clean up
                self.performSelectorOnMainThread("cacheImage:", withObject: nil, waitUntilDone: true)
            }
        }
    }

    func connection(connection: __unused NSURLConnection, didReceiveData data: NSData) {
        //add data
        self.data.appendData(data)
    }

    func connectionDidFinishLoading(connection: __unused NSURLConnection) {
        self.performSelectorInBackground("processDataInBackground:", withObject: self.data)
        self.connection = nil
        self.data = nil
    }

    func connection(connection: __unused NSURLConnection, didFailWithError error: NSError) {
        self.connection = nil
        self.data = nil
        self.loadFailedWithError(error)
    }

    func connection(connection: NSURLConnection, willSendRequestForAuthenticationChallenge challenge: NSURLAuthenticationChallenge) {
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) && challenge.protectionSpace.host.hasSuffix("s3.amazonaws.com") {
            // accept the certificate anyway
            challenge.sender.useCredential(NSURLCredential.credentialForTrust(challenge.protectionSpace.serverTrust), forAuthenticationChallenge: challenge)
        }
        else {
            challenge.sender.continueWithoutCredentialForAuthenticationChallenge(challenge)
        }
    }
}