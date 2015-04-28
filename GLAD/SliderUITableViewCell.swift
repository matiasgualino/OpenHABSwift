//
//  SliderUITableViewCell.swift
//  GLAD
//
//  Created by Matias Gualino on 3/4/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import Foundation
import UIKit

class SliderUITableViewCell : GenericUITableViewCell {
    var widgetSlider : UISlider!
    @IBOutlet weak private var label : UILabel!
	
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.widgetSlider = self.viewWithTag(400) as? UISlider
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.separatorInset = UIEdgeInsetsZero
    }
    
    override func displayWidget() {
        self.label.text = self.widget.labelText()
		self.label.textColor = UIColor.whiteColor()
        let widgetValue = widget.item.stateAsFloat()
        self.widgetSlider.value = widgetValue / 100.0
        self.widgetSlider.addTarget(self, action: "sliderDidEndSliding:", forControlEvents: (UIControlEvents.TouchUpInside | UIControlEvents.TouchUpOutside))
		self.detailTextLabel?.font = UIFont(name: "HelveticaNeue", size: 14.0)
		self.label.font = UIFont(name: "HelveticaNeue", size: 15.0)
    }
	
    func sliderDidEndSliding(notification: NSNotification) {
        println(String(format:"Slider new value = %f", self.widgetSlider.value))
        let intValue = Int(self.widgetSlider.value * 100)
        self.widget.sendCommand(String(format:"%d", intValue))
    }
    
}