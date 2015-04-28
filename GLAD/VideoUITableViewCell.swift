//
//  VideoUITableViewCell.swift
//  GLAD
//
//  Created by Matias Gualino on 4/4/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

class VideoUITableViewCell : GenericUITableViewCell {
    
    override var frame: CGRect {
        get {
            return self.frame
        }
        set {
            println("setFrame")
            super.frame = newValue
            //    [videoPlayer.view setFrame:frame];
        }
    }
    
    var videoPlayer : MPMoviePlayerController!
    
    override func loadWidget(widgetToLoad: OpenHABWidget) {
        self.widget = widgetToLoad
    }
    
    override func displayWidget() {
        println("Video url = \(widget.url)")
		self.detailTextLabel?.font = UIFont(name: "HelveticaNeue", size: 14.0)
		self.textLabel?.font = UIFont(name: "HelveticaNeue", size: 15.0)
        //    videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:widget.url]];
        //    videoPlayer.view.frame = self.contentView.bounds;
        //    [self.contentView addSubview:videoPlayer.view];
        //    [videoPlayer prepareToPlay];
        //    [videoPlayer play];
    }
    
}