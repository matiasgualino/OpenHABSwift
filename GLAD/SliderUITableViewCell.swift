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
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.widgetSlider = self.viewWithTag(400) as? UISlider
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.separatorInset = UIEdgeInsetsZero
    }
    
    override func displayWidget() {
        self.textLabel?.text = self.widget.labelText()
        let widgetValue = widget.item.stateAsFloat()
        self.widgetSlider.value = widgetValue / 100.0
        self.widgetSlider.addTarget(self, action: "sliderDidEndSlidind:", forControlEvents: (UIControlEvents.TouchUpInside | UIControlEvents.TouchUpOutside))
    }
    
    func sliderDidEndSliding(notification: NSNotification) {
        println(String(format:"Slider new value = %f", self.widgetSlider.value))
        let intValue = self.widgetSlider.value * 100
        self.widget.sendCommand(String(format:"%d", intValue))
    }
    
}