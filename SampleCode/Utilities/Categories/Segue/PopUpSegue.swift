//
//  KNPopUpSegue.h
//
//  Created by NUS Technology on 9/24/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//
import UIKit
class PopUpSegue: UIStoryboardSegue {

    func perform() {
        var sourceController: UIViewController = self.sourceViewController
        var destinationController: UIViewController = self.destinationViewController
        destinationController.modalPresentationStyle = UIModalPresentationOverFullScreen
        sourceController.presentViewController(destinationController, animated: true, completion: {() -> Void in
        })
        destinationController.transitionCoordinator.animateAlongsideTransition({(context: UIViewControllerTransitionCoordinatorContext) -> Void in
        }, completion: { _ in })
    }
}
//
//  KNPopUpSegue.m
//
//  Created by NUS Technology on 9/24/14.
//  Copyright (c) 2014 Sample Code. All rights reserved.
//