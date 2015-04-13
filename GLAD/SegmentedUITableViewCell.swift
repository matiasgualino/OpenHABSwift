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
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.widgetSegmentedControl = self.viewWithTag(500) as? UISegmentedControl
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.separatorInset = UIEdgeInsetsZero
    }
    
    override func displayWidget() {
        self.textLabel?.text = self.widget.labelText()
        widgetSegmentedControl.apportionsSegmentWidthsByContent = true
        self.widgetSegmentedControl.removeAllSegments()
        self.widgetSegmentedControl.apportionsSegmentWidthsByContent = true
                self.widgetSegmentedControl.addTarget(self, action: "pickOne:", forControlEvents: UIControlEvents.ValueChanged)
        var i = 0
        for mapping in self.widget.mappings {
            self.widgetSegmentedControl.insertSegmentWithTitle(mapping.label, atIndex: i, animated: false)
            i++
        }
        self.widgetSegmentedControl.selectedSegmentIndex = self.widget.mappingIndexByCommand(self.widget.item.state)
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