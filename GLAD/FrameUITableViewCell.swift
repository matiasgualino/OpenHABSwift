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
 
	@IBOutlet weak private var label : UILabel!
	
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //        textLabel = self.viewWithTag(100) as? UILabel
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.separatorInset = UIEdgeInsetsMake(0, 30, 0, 0)
    }
    
    override func displayWidget() {
        self.label.text = self.widget.label.uppercaseString
        self.label.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
		self.label.textColor = UIColor.whiteColor()
        self.contentView.sizeToFit()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}