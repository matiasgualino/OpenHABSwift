//
//  SelectionUITableViewCell.swift
//  GLAD
//
//  Created by Matias Gualino on 3/4/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import Foundation
import UIKit

class SelectionUITableViewCell : GenericUITableViewCell {
	
	@IBOutlet weak private var label : UILabel!
	@IBOutlet weak private var det : UILabel!
	
    override func displayWidget() {
        self.label.text = self.widget.labelText()
		self.label.textColor = UIColor.whiteColor()
		self.det.textColor = UIColor.whiteColor()
        let selectedMapping = self.widget.mappingIndexByCommand(self.widget.item.state)
        if selectedMapping != -1 {
            let widgetMapping = widget.mappings[selectedMapping]
            self.det.text = widgetMapping.label
        }
		self.det.font = UIFont(name: "HelveticaNeue", size: 14.0)
		self.label.font = UIFont(name: "HelveticaNeue", size: 15.0)
    }
	
    override func loadWidget(widgetToLoad: OpenHABWidget) {
        self.widget = widgetToLoad
        self.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        self.selectionStyle = UITableViewCellSelectionStyle.Blue
    }
    
}