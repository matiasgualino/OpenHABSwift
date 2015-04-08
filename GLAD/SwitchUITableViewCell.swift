//
//  SwitchUITableViewCell.swift
//  GLAD
//
//  Created by Matias Gualino on 3/4/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import Foundation
import UIKit

class SwitchUITableViewCell : GenericUITableViewCell {
    var widgetSwitch : UISwitch!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.widgetSwitch = self.viewWithTag(200) as? UISwitch
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.separatorInset = UIEdgeInsetsZero
    }
    
    override func displayWidget() {
        self.textLabel?.text = self.widget.labelText()
        if self.widget.labelValue() != nil {
            self.detailTextLabel?.text = self.widget.labelValue()
        } else {
            self.detailTextLabel?.text = nil
        }
        
        if self.widget.item.state == "ON" {
            self.widgetSwitch.on = true
        } else {
            self.widgetSwitch.on = false
        }
        
        self.widgetSwitch.addTarget(self, action: "switchChange:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func switchChange(sender: AnyObject) {
        if self.widgetSwitch.on {
            self.widget.sendCommand("ON")
        } else {
            self.widget.sendCommand("OFF")
        }
    }
    
}