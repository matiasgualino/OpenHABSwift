//
//  RollershutterUITableViewCell.swift
//  GLAD
//
//  Created by Matias Gualino on 3/4/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import Foundation
import UIKit

class RollershutterUITableViewCell : GenericUITableViewCell {
    var downButton : UIButton!
    var stopButton : UIButton!
    var upButton : UIButton!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.upButton = self.viewWithTag(601) as? UIButton
        self.stopButton = self.viewWithTag(602) as? UIButton
        self.downButton = self.viewWithTag(603) as? UIButton

        var upCode : [unichar] = [0x25b2]
        var stopCode : [unichar] = [0x25a0]
        var downCode : [unichar] = [0x25bc]
        self.upButton.setTitle(NSString(characters: &upCode, length: 1) as String, forState: UIControlState.Normal)
        self.stopButton.setTitle(NSString(characters: &stopCode, length: 1) as String, forState: UIControlState.Normal)
        self.downButton.setTitle(NSString(characters: &downCode, length: 1) as String, forState: UIControlState.Normal)
        
        self.upButton.addTarget(self, action: "upButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.stopButton.addTarget(self, action: "stopButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.downButton.addTarget(self, action: "downButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.separatorInset = UIEdgeInsetsZero
        
    }
    
    func upButtonPressed() {
        println("up button pressed")
        self.widget.sendCommand("UP")
    }
    
    func stopButtonPressed() {
        println("stop button pressed")
        self.widget.sendCommand("STOP")
    }
    
    func downButtonPressed() {
        println("down button pressed")
        self.widget.sendCommand("DOWN")
    }
    
}