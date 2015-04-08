//
//  ColorPickerUITableViewCell.swift
//  GLAD
//
//  Created by Matias Gualino on 3/4/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import Foundation
import UIKit

class ColorPickerUITableViewCell : GenericUITableViewCell {
    var upButton : UICircleButton!
    var colorButton : UICircleButton!
    var downButton : UICircleButton!
    var callbackPressColorButton : ((colorPickerUITableViewCell: ColorPickerUITableViewCell) -> Void)?

    convenience init(coder aDecoder: NSCoder, callbackPressColorButton: ((colorPickerUITableViewCell: ColorPickerUITableViewCell) -> Void)?) {
        self.init(coder: aDecoder)
        self.callbackPressColorButton = callbackPressColorButton
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.upButton = self.viewWithTag(701) as? UICircleButton
        self.colorButton = self.viewWithTag(702) as? UICircleButton
        self.downButton = self.viewWithTag(703) as? UICircleButton
        
        var upCode : [unichar] = [0x25b2]
        var downCode : [unichar] = [0x25bc]
        self.upButton.setTitle(NSString(characters: &upCode, length: 1), forState: UIControlState.Normal)
        self.downButton.setTitle(NSString(characters: &downCode, length: 1), forState: UIControlState.Normal)
        
        self.upButton.addTarget(self, action: "upButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.colorButton.addTarget(self, action: "colorButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.downButton.addTarget(self, action: "downButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.separatorInset = UIEdgeInsetsZero
    }
    
    override func displayWidget() {
        self.textLabel?.text = self.widget.labelText()
        colorButton.backgroundColor = self.widget.item.stateAsUIColor()
    }
    
    
    func upButtonPressed() {
        self.widget.sendCommand("ON")
    }
    
    func colorButtonPressed() {
        if self.callbackPressColorButton != nil {
            self.callbackPressColorButton!(colorPickerUITableViewCell: self)
        }
    }
    
    func downButtonPressed() {
        self.widget.sendCommand("OFF")
    }
}