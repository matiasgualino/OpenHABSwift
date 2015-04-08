//
//  UICircleButton.swift
//  GLAD
//
//  Created by Matias Gualino on 2/4/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import Foundation
import UIKit

class UICircleButton : UIButton {
    
    var normalBackgroundColor : UIColor!
    var normalTextColor : UIColor!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 20.0)
        self.layer.cornerRadius = self.bounds.size.width/2.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = self.titleLabel?.textColor.CGColor
        self.addTarget(self, action: "buttonActionReleased", forControlEvents: UIControlEvents.TouchUpInside)
        self.addTarget(self, action: "buttonActionTouched", forControlEvents: UIControlEvents.TouchDown)
        normalBackgroundColor = self.backgroundColor!
    }
    
    func buttonActionReleased() {
        
    }
    
    func buttonActionTouched() {
        self.backgroundColor = normalTextColor
        normalTextColor = self.titleLabel?.textColor
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "timerTicked", userInfo: nil, repeats: false)
    }
    
    func timerTicked(timer: NSTimer) {
        self.backgroundColor = normalBackgroundColor
        self.setTitleColor(normalTextColor, forState: UIControlState.Normal)
        timer.invalidate()
    }

}