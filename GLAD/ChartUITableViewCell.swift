//
//  ChartUITableViewCell.swift
//  GLAD
//
//  Created by Matias Gualino on 4/4/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import Foundation
import UIKit

class ChartUITableViewCell : ImageUITableViewCell {
    var baseUrl : String!
    
    override func displayWidget() {
        self.widgetImage = self.viewWithTag(801) as? UIImageView
        var chartUrl : String?
        var random = arc4random() % 1000
        if self.widget.item.type == "GroupItem" {
            chartUrl = "\(self.baseUrl!)/chart?groups=\(self.widget.item.name)&period=\(self.widget.period)&random=\(random)"
        } else {
            chartUrl = "\(self.baseUrl!)/chart?items=\(self.widget.item.name)&period=\(self.widget.period)&random=\(random)"
        }
        if self.widget.service != nil && self.widget.service.utf16Count > 0 {
            chartUrl = "\(chartUrl)&service=\(self.widget.service)"
        }
        println("Chart url \(chartUrl)")
        if widget.image == nil {
            self.widgetImage.sd_setImageWithURL(NSURL(string: chartUrl!), placeholderImage: nil, options: SDWebImageOptions.CacheMemoryOnly, completed: { (image, error, cacheType, url) -> Void in
                //        NSLog(@"Image load complete %f %f", self.widgetImage.image.size.width, self.widgetImage.image.size.height);
                self.widget.image = self.widgetImage.image
                self.widgetImage.frame = self.contentView.frame
                if self.callbackDidLoadImage != nil {
                    self.callbackDidLoadImage!()
                }
            })
        } else {
            self.widgetImage.image = widget.image
        }

    }
    
}