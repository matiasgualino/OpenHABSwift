//
//  SegmentedUITableViewCell.swift
//  GLAD
//
//  Created by Matias Gualino on 3/4/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import Foundation
import UIKit

class SegmentedUITableViewCell : GenericUITableViewCell {

    var widgetSegmentedControl : UISegmentedControl!
	
	@IBOutlet weak private var label : UILabel!
	
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.widgetSegmentedControl = self.viewWithTag(500) as? UISegmentedControl
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.separatorInset = UIEdgeInsetsZero
    }
    
    override func displayWidget() {
        self.label.text = self.widget.labelText()
		self.label.textColor = UIColor.whiteColor()
        self.widgetSegmentedControl.apportionsSegmentWidthsByContent = true
        self.widgetSegmentedControl.removeAllSegments()
        var i = 0
        for mapping in self.widget.mappings {
            self.widgetSegmentedControl.insertSegmentWithTitle(mapping.label, atIndex: i, animated: false)
            i++
        }
        self.widgetSegmentedControl.selectedSegmentIndex = self.widget.mappingIndexByCommand(self.widget.item.state)
        self.widgetSegmentedControl.addTarget(self, action: "pickOne:", forControlEvents: UIControlEvents.ValueChanged)
		self.detailTextLabel?.font = UIFont(name: "HelveticaNeue", size: 14.0)
		self.label.font = UIFont(name: "HelveticaNeue", size: 15.0)
    }
	
    func pickOne(sender: AnyObject) {
        var segmentedControl : UISegmentedControl? = sender as? UISegmentedControl
        println(String(format:"Segment pressed %d", segmentedControl!.selectedSegmentIndex))
        if self.widget.mappings != nil {
            var mapping : OpenHABWidgetMapping = self.widget.mappings[segmentedControl!.selectedSegmentIndex]
            self.widget.sendCommand(mapping.command)
        }

    }
    
}