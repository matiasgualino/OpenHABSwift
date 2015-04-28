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
    @IBOutlet weak private var label : UILabel!
	
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.widgetSwitch = self.viewWithTag(200) as? UISwitch
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.separatorInset = UIEdgeInsetsZero
    }
    
    override func displayWidget() {
        self.label.text = self.widget.labelText()
		self.label.textColor = UIColor.whiteColor()
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
		
		self.detailTextLabel?.font = UIFont(name: "HelveticaNeue", size: 14.0)
		self.label.font = UIFont(name: "HelveticaNeue", size: 15.0)
    }
	
    func switchChange(sender: AnyObject) {
        if self.widgetSwitch.on {
            self.widget.sendCommand("ON")
        } else {
            self.widget.sendCommand("OFF")
        }
    }
    
}