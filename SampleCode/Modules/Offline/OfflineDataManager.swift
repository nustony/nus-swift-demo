//
//  OfflineDataManager.h
//
//  Created by NUS Technology on 9/9/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//
import Foundation
protocol OfflineDataManagerDelegate: NSObject {
    func didChangeConnectionStatus(isConnected: Bool)

    func didFailWithErrorWhenRequestAPI(error: NSError)
}
class OfflineDataManager: NSObject, OfflineDataManagerDelegate {
    weak var delegate: protocol<NSObject, OfflineDataManagerDelegate>
    // Methods

    func startInternetNotifier() {
        //[internetReachability startNotifier];
    }

    func stopInternetNotifier() {
        //[internetReachability stopNotifier];
    }

    func synchronizeData() {
    }

    func getLocalData() {
    }
    var connectionManager: AFNetworkReachabilityManager


    convenience override init() {
        super.init()
                self.delegate = self
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: AFNetworkingReachabilityDidChangeNotification, object: nil)
    }
    // Methods
    // Called by Reachability whenever status changes.

    func reachabilityChanged(note: NSNotification) {
        var myClient: APIClient = APIClient.sharedInstance()
        if myClient.isConnected {
            self.synchronizeData()
            if self.delegate && self.delegate.respondsToSelector("didChangeConnectionStatus:") {
                self.delegate.didChangeConnectionStatus(true)
            }
        }
        else {
            if self.delegate && self.delegate.respondsToSelector("didChangeConnectionStatus:") {
                self.delegate.didChangeConnectionStatus(false)
            }
        }
    }

    func didFailWithErrorWhenRequestAPI(error: NSError) {
        if error.code == 1009 {
            self.showMessage(error.localizedDescription, withTitle: "Error")
        }
    }

    func showMessage(msg: String, withTitle title: String) {
        var alert: UIAlertView = UIAlertView(title: title, message: msg, delegate: self, cancelButtonTitle: "OK", otherButtonTitles: "")
        alert.show()
    }
}
//
//  OfflineDataManager.m
//
//  Created by NUS Technology on 9/9/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//