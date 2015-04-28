//
//  SetpointUITableViewCell.swift
//  GLAD
//
//  Created by Matias Gualino on 3/4/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import Foundation
import UIKit

class SetpointUITableViewCell : GenericUITableViewCell {

    var widgetSegmentedControl : UISegmentedControl!
    @IBOutlet weak private var label : UILabel!
	
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.widgetSegmentedControl = self.viewWithTag(300) as? UISegmentedControl
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.separatorInset = UIEdgeInsetsZero
    }

    override func displayWidget() {
        self.label.text = self.widget.labelText()
		self.label.textColor = UIColor.whiteColor()
        var widgetValue : String?
        if self.widget.item.state == "Uninitialized" {
            widgetValue = "N/A"
        } else {
            widgetValue = String(format:"%.01f", self.widget.item.stateAsFloat())
        }
        
        self.widgetSegmentedControl.setTitle(widgetValue, forSegmentAtIndex: 1)
        self.widgetSegmentedControl.addTarget(self, action: "pickOne:", forControlEvents: UIControlEvents.ValueChanged)
		
		self.detailTextLabel?.font = UIFont(name: "HelveticaNeue", size: 14.0)
		self.label.font = UIFont(name: "HelveticaNeue", size: 15.0)
    }
	
    func pickOne(sender: AnyObject) {
        var segmentedControl = sender as? UISegmentedControl
        println(String(format:"Setpoint pressed %d", segmentedControl!.selectedSegmentIndex))
        if segmentedControl?.selectedSegmentIndex == 1 {
            self.widgetSegmentedControl.selectedSegmentIndex = -1
        } else if segmentedControl?.selectedSegmentIndex == 0 {
            if self.widget.item.state == "Uninitialized" {
                self.widget.sendCommand(self.widget.minValue)
            } else {
                if self.widget.minValue != nil {
                    if self.widget.item.stateAsFloat() - (self.widget.step as NSString).floatValue >= (self.widget.minValue as NSString).floatValue {
                        self.widget.sendCommand(String(format:"%.01f", self.widget.item.stateAsFloat() - (self.widget.step as NSString).floatValue))
                    }
                } else {
                        self.widget.sendCommand(String(format:"%.01f", self.widget.item.stateAsFloat() - (self.widget.step as NSString).floatValue))
                }
            }
        } else if segmentedControl?.selectedSegmentIndex == 2 {
            if self.widget.item.state == "Uninitialized" {
                self.widget.sendCommand(self.widget.minValue)
            } else {
                if self.widget.maxValue != nil {
                    if self.widget.item.stateAsFloat() + (self.widget.step as NSString).floatValue <= (self.widget.maxValue as NSString).floatValue {
                        self.widget.sendCommand(String(format:"%.01f", self.widget.item.stateAsFloat() + (self.widget.step as NSString).floatValue))
                    }
                } else {
                    self.widget.sendCommand(String(format:"%.01f", self.widget.item.stateAsFloat() + (self.widget.step as NSString).floatValue))
                }
            }
        }
    }
    
}
