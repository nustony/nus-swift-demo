//
//  YDAsyncQueue.h
//  GCDDownloader
//
//  Created by Dev on 03/09/2013.
//  Copyright (c) 2013 Dev. All rights reserved.
//
import Foundation
//This is theAsyncQueue

protocol YDAsyncQueueDelegate: NSObject {
}
class YDAsyncQueue: NSObject {
    // Will be called when a request completes with the request as the argument
    var requestDidFinishSelector: Selector
    var requestDidFailSelector: Selector
    var queueDidFinishSelector: Selector
    var queueDidFailSelector: Selector

    //public properties
    weak var delegate: YDAsyncQueueDelegate
    var requestDidFinishSelector: Selector
    var requestDidFailSelector: Selector
    var queueDidFinishSelector: Selector
    var queueDidFailSelector: Selector
    var requestsInQueue: Int {
        get {
            return self.requestsInQueue
        }
    }

    //selectors
    //pconstructor

    override init(dispatchQueue aSyncQueue: dispatch_queue_t) {
        if (super.init()) {
            self.currentQueue = aSyncQueue
            self.initializeQueue()
        }
    }

    override init(queuePriority priority: dispatch_queue_priority_t) {
        if (super.init()) {
            var aSyncQueue: dispatch_queue_t = dispatch_get_global_queue(priority, 0)
            self.currentQueue = aSyncQueue
            self.initializeQueue()
        }
    }
    //public methods

    func addRequest(request: YDAsyncRequest) {
        //need a queue to store it
        queuedRequests.append(request)
        self.requestsInQueue = queuedRequests.count
    }

    func startQueue() {
        dispatch_async(self.currentQueue, {() -> Void in
            for var i = 0; i < queuedRequests.count; i++ {
                    //execute the request
                var currentRequest: YDAsyncRequest = queuedRequests[i]
                currentRequest.delegate = self
                currentRequest.requestDidFinishSelector = "requestFinished:"
                currentRequest.requestDidFailSelector = "requestFailed:"
                currentRequest.startRequest()
            }
        })
    }

    override func initializeQueue() {
        queuedRequests = [AnyObject]()
    }
    //private methods

    func requestFinished(request: YDAsyncRequest) {
        queuedRequests.removeObject(request)
        var mainQueue: dispatch_queue_t = dispatch_get_main_queue()
        dispatch_async(mainQueue, {() -> Void in
            if self.requestDidFinishSelector() {
                SuppressPerformSelectorLeakWarning(self.delegate.performSelector(self.requestDidFinishSelector(), withObject: self))
            }
        })
    }

    func requestFailed(request: YDAsyncRequest) {
        var mainQueue: dispatch_queue_t = dispatch_get_main_queue()
        dispatch_async(mainQueue, {() -> Void in
            if self.requestDidFailSelector() {
                SuppressPerformSelectorLeakWarning(self.delegate.performSelector(self.requestDidFailSelector(), withObject: self))
            }
        })
    }

    func queueFinished() {
        if self.queueDidFinishSelector() {
            var mainQueue: dispatch_queue_t = dispatch_get_main_queue()
            dispatch_async(mainQueue, {() -> Void in
                SuppressPerformSelectorLeakWarning(self.delegate.performSelector(self.queueDidFinishSelector(), withObject: self))
            })
        }
    }

    func queueFailed() {
        var mainQueue: dispatch_queue_t = dispatch_get_main_queue()
        dispatch_async(mainQueue, {() -> Void in
            if self.queueDidFailSelector() {
                SuppressPerformSelectorLeakWarning(self.delegate.performSelector(self.queueDidFailSelector(), withObject: self))
            }
        })
    }
    //public methods
    //adds a YDAsyncRequest to the queue

    func requestDidFinish() {
        if queuedRequests.count == 0 {
            var mainQueue: dispatch_queue_t = dispatch_get_main_queue()
            dispatch_async(mainQueue, {() -> Void in
                self.queueFinished()
            })
        }
    }

    func requestDidFail() {
        if queuedRequests.count == 0 {
            var mainQueue: dispatch_queue_t = dispatch_get_main_queue()
            dispatch_async(mainQueue, {() -> Void in
                self.queueFinished()
            })
        }
    }
    var queuedRequests: [AnyObject]
    var requestsInQueue: Int


    var currentQueue: dispatch_queue_t
}
//
//  YDAsyncQueue.m
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