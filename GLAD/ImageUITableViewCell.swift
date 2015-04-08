//
//  ImageUITableViewCell.swift
//  GLAD
//
//  Created by Matias Gualino on 4/4/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import Foundation
import UIKit

class ImageUITableViewCell : GenericUITableViewCell {
    var widgetImage : UIImageView!
    var refreshTimer : NSTimer!
    var callbackDidLoadImage : (() -> Void)?
    
    override func loadWidget(widgetToLoad: OpenHABWidget) {
        self.widget = widgetToLoad
    }
    
    override func displayWidget() {
        self.widgetImage = self.viewWithTag(901) as? UIImageView
        if self.widget.image == nil {
            self.loadImage()
        } else {
            self.widgetImage.image = self.widget.image
        }
        
        if self.widget.refresh != nil && refreshTimer == nil {
            var refreshInterval : NSTimeInterval = (self.widget.refresh as NSString).doubleValue / 1000.0
            refreshTimer = NSTimer.scheduledTimerWithTimeInterval(refreshInterval, target: self, selector: "refreshImage:", userInfo: nil, repeats: true)
        }
    }
    
    func loadImage() {
        var random = arc4random() % 1000
        
        self.widgetImage.sd_setImageWithURL(NSURL(string: String(format: "%@&random=%d", self.widget.url, random)), placeholderImage: nil, options: SDWebImageOptions.CacheMemoryOnly){ (image, error, cacheType, imageURL) -> Void in
            self.widget.image = self.widgetImage.image
            self.widgetImage.frame = self.contentView.frame
            if self.callbackDidLoadImage != nil {
                self.callbackDidLoadImage!()
            }
        }
    }
    
    func refreshImage(timer: NSTimer) {
        var random = arc4random() % 1000
        widgetImage.sd_setImageWithURL(NSURL(string: String(format: "%@&random=%d", self.widget.url, random)), placeholderImage: self.widgetImage.image, options: SDWebImageOptions.CacheMemoryOnly) { (image, error, cacheType, imageURL) -> Void in
            self.widget.image = self.widgetImage.image
        }
    }
    
    override func willMoveToWindow(newWindow: UIWindow!) {
        super.willMoveToWindow(newWindow)
        if newWindow == nil && refreshTimer != nil {
            refreshTimer.invalidate()
            refreshTimer = nil
        }
    }
    
}