//
//  GenericUITableViewCell.swift
//  GLAD
//
//  Created by Matias Gualino on 3/4/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import Foundation
import UIKit

class GenericUITableViewCell : UITableViewCell {
	
	@IBOutlet weak private var labell : UILabel!
	@IBOutlet weak private var detail : UILabel!
	
    var widget : OpenHABWidget!
	var widgetMapping : OpenHABWidgetMapping!
    var disclosureConstraints : [NSLayoutConstraint]!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //        self.textLabel = self.viewWithTag(101) as? UILabel
        //self.detailTextLabel = self.viewWithTag(100) as? UILabel
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.separatorInset = UIEdgeInsetsZero
		self.layoutMargins = UIEdgeInsetsZero
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame = CGRectMake(13, 5, 32, 32)
    }
	
    func loadWidget(widgetToLoad: OpenHABWidget) {
        self.widget = widgetToLoad
        if widget.linkedPage != nil {
            self.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            self.selectionStyle = UITableViewCellSelectionStyle.Blue
        } else {
            self.accessoryType = UITableViewCellAccessoryType.None
            self.selectionStyle = UITableViewCellSelectionStyle.None
        }
    }
	
	func loadWidgetMapping(widgetToLoad: OpenHABWidgetMapping) {
		self.widgetMapping = widgetToLoad
		self.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
		self.selectionStyle = UITableViewCellSelectionStyle.Blue
	}
	
	func displayWidgetMapping() {
		if self.labell != nil && self.detail != nil {
			self.labell.text = self.widgetMapping.label
			self.detail.text = nil
			if self.disclosureConstraints != nil {
				self.removeConstraints(self.disclosureConstraints)
				disclosureConstraints = nil
			}
			self.imageView?.frame = CGRectMake(0, 0, 0, 0)
			self.labell.textColor = UIColor.whiteColor()
			self.labell.font = UIFont(name: "HelveticaNeue", size: 15.0)
			self.labell.sizeToFit()
		}
	}
	
    func displayWidget() {
		if self.labell != nil && self.detail != nil {
        self.labell.text = self.widget.labelText()

        if self.widget.labelValue() != nil {
            self.detail.text = self.widget.labelValue()
        } else {
            self.detail.text = nil
        }
        
        if self.disclosureConstraints != nil {
            self.removeConstraints(self.disclosureConstraints)
            disclosureConstraints = nil
        }
		if self.widget.valuecolor != nil {
			self.detail.textColor = UIColor.colorWithHexString(self.widget.valuecolor)
		} else {
			self.detail.textColor = UIColor.whiteColor()
		}
		
		if self.widget.labelcolor != nil {
			self.labell.textColor = UIColor.colorWithHexString(self.widget.labelcolor)
		} else {
			self.labell.textColor = UIColor.whiteColor()
		}
			
		self.detail.textColor = UIColor.whiteColor()
		self.labell.textColor = UIColor.whiteColor()
			self.detail.numberOfLines = 1
			self.detail.minimumScaleFactor = 0.3
			self.detail.adjustsFontSizeToFitWidth = true
			//		self.detail.font = UIFont(name: "HelveticaNeue", size: 14.0)
		self.labell.font = UIFont(name: "HelveticaNeue", size: 15.0)
			self.labell.sizeToFit()
			self.detail.sizeToFit()
		}
       /* if self.accessoryType == UITableViewCellAccessoryType.None {
            // If accessory is disabled, set detailTextLabel (widget value) constraing 20px to the right for padding to the right side of table view
            if self.detailTextLabel != nil {
                self.disclosureConstraints = NSLayoutConstraint.constraintsWithVisualFormat("[detailTextLabel]-20.0-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["detailTextLabel" : detailTextLabel!]) as? [NSLayoutConstraint]
                self.addConstraints(disclosureConstraints)
            }
        } else {
                // If accessory is enabled, set detailTextLabel (widget value) constraint 0px to the right               
                if self.detailTextLabel != nil {
                    self.disclosureConstraints = NSLayoutConstraint.constraintsWithVisualFormat("[detailTextLabel]|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["detailTextLabel" : detailTextLabel!]) as? [NSLayoutConstraint]
                    self.addConstraints(disclosureConstraints)
                }
        }*/
        
		
		
    }
}