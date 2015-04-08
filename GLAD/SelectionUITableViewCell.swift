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
    
    override func displayWidget() {
        self.textLabel?.text = self.widget.labelText()
        let selectedMapping = self.widget.mappingIndexByCommand(self.widget.item.state)
        if selectedMapping != -1 {
            let widgetMapping = widget.mappings[selectedMapping]
            self.detailTextLabel?.text = widgetMapping.label
        }
    }
    
    override func loadWidget(widgetToLoad: OpenHABWidget) {
        self.widget = widgetToLoad
        self.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        self.selectionStyle = UITableViewCellSelectionStyle.Blue
    }
    
}