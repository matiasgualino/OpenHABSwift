//
//  UIAlertView+Block.swift
//  GLAD
//
//  Created by Matias Gualino on 2/4/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

class NSCBAlertWrapper {
    var completionBlock:((alertView: UIAlertView, buttonIndex: Int) -> Void)!

    // Called when a button is clicked. The view will be automatically dismissed after this call returns
    func alertView(alertView : UIAlertView, buttonIndex: Int) {
        if self.completionBlock != nil {
            self.completionBlock(alertView: alertView, buttonIndex: buttonIndex)
        }
    }
    
    func alertViewCancel(alertView: UIAlertView) {
        if self.completionBlock != nil {
            self.completionBlock(alertView: alertView, buttonIndex: alertView.cancelButtonIndex)
        }
    }
    
}

var kNSCBAlertWrapper : UInt8 = 0

extension UIAlertView {
  
    func showWithCompletion(completion:((alertView: UIAlertView, buttonIndex: Int) -> Void)) {
        var alertWrapper : NSCBAlertWrapper = NSCBAlertWrapper()
        alertWrapper.completionBlock = completion
        self.delegate = alertWrapper
        // Set the wrapper as an associated object
        objc_setAssociatedObject(self, &kNSCBAlertWrapper, alertWrapper, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        // Show the alert as normal
        self.show()
    }
    
}