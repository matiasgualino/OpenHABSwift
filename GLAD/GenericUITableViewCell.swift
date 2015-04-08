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
    override var textLabel: UILabel? {
        get {
            return self.textLabel
        }
        set {
            self.textLabel = newValue
        }
    }
    
    override var detailTextLabel: UILabel? {
        get {
            return self.detailTextLabel
        }
        set {
            self.detailTextLabel = newValue
        }
    }
    
    var widget : OpenHABWidget!
    var disclosureConstraints : [NSLayoutConstraint]!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textLabel = self.viewWithTag(101) as? UILabel
        self.detailTextLabel = self.viewWithTag(100) as? UILabel
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.separatorInset = UIEdgeInsetsZero
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
    
    func displayWidget() {
        self.textLabel?.text = self.widget.labelText()
        if self.widget.labelValue() != nil {
            self.detailTextLabel?.text = self.widget.labelValue()
        } else {
            self.detailTextLabel?.text = nil
        }
        self.detailTextLabel?.sizeToFit()
        
        if self.disclosureConstraints != nil {
            self.removeConstraints(self.disclosureConstraints)
            disclosureConstraints = nil
        }
        
        if self.accessoryType == UITableViewCellAccessoryType.None {
            // If accessory is disabled, set detailTextLabel (widget value) constraing 20px to the right for padding to the right side of table view
            if self.detailTextLabel != nil {
                self.disclosureConstraints = NSLayoutConstraint.constraintsWithVisualFormat("[detailTextLabel]-20.0-|", options: 0, metrics: nil, views: NSDictionaryOfVariableBindings(detailTextLabel))
                self.addConstraints(disclosureConstraints)
            }
        } else {
                // If accessory is enabled, set detailTextLabel (widget value) constraint 0px to the right               
                if self.detailTextLabel != nil {
                    self.disclosureConstraints = NSLayoutConstraint.constraintsWithVisualFormat("[detailTextLabel]|", options: 0, metrics: nil, views: NSDictionaryOfVariableBindings(detailTextLabel))
                    self.addConstraints(disclosureConstraints)
                }
        }
        
        if self.widget.valuecolor != nil {
            self.detailTextLabel?.textColor = UIColor.colorWithHexString(self.widget.valuecolor)
        } else {
            self.detailTextLabel?.textColor = UIColor.lightGrayColor()
        }
        
        if self.widget.labelcolor != nil {
            self.textLabel?.textColor = UIColor.colorWithHexString(self.widget.labelcolor)
        } else {
            self.textLabel?.textColor = UIColor.blackColor()
        }
        
    }
}