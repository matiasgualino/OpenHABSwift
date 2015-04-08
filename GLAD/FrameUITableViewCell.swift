//
//  FrameUITableViewCell.swift
//  GLAD
//
//  Created by Matias Gualino on 3/4/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import Foundation
import UIKit

class FrameUITableViewCell : GenericUITableViewCell {
    override var textLabel: UILabel? {
        get {
            return self.textLabel
        }
        set {
            self.textLabel = newValue
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textLabel = self.viewWithTag(100) as? UILabel
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.separatorInset = UIEdgeInsetsZero
    }
    
    override func displayWidget() {
        self.textLabel?.text = self.widget.label.uppercaseString
        self.contentView.sizeToFit()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}