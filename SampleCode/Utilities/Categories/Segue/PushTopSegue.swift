//
//  KNPushTopSegue.h
//  NUS Technology
//
//  Created by NUS Technology on 6/26/14.
//
//
import UIKit
class PushTopSegue: UIStoryboardSegue {

    func perform() {
        var oldView: UIView = ((self.sourceViewController as! UIViewController)).view!
        var newView: UIView = ((self.destinationViewController as! UIViewController)).view!
        self.sourceViewController.presentViewController(self.destinationViewController, animated: false, completion: { _ in })
        newView.window.insertSubview(oldView, aboveSubview: newView)
        var offsetY: Float = oldView.frame.size.height
        UIView.animateWithDuration(0.3, animations: {() -> Void in
            oldView.frame = CGRectMake(oldView.frame.origin.x, oldView.frame.origin.y - offsetY, oldView.frame.size.width, oldView.frame.size.height)
        }, completion: {(finished: Bool) -> Void in
            oldView.removeFromSuperview()
        })
    }
}
//
//  KNPushTopSegue.m
//  NUS Technology
//
//  Created by NUS Technology on 6/26/14.
//
//