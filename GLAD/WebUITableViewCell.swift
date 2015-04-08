//
//  WebUITableViewCell.swift
//  GLAD
//
//  Created by Matias Gualino on 4/4/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import Foundation
import UIKit

class WebUITableViewCell : GenericUITableViewCell, UIWebViewDelegate {
    
    override var frame: CGRect {
        get {
            return self.frame
        }
        set {
            println("setFrame")
            super.frame = newValue
            self.widgetWebView.reload()
        }
    }
    
    var widgetWebView : UIWebView!
    var isLoadingUrl : Bool!
    var isLoaded : Bool!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.separatorInset = UIEdgeInsetsZero
        widgetWebView = self.viewWithTag(1001) as? UIWebView
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        println("webview started loading")
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        println("webview finished load")
    }
    
    override func loadWidget(widgetToLoad: OpenHABWidget) {
        self.widget = widgetToLoad
    }
    
    override func displayWidget() {
        println("webview loading url \(self.widget.url!)")
        var nsurl = NSURL(string: self.widget.url)
        var nsrequest : NSURLRequest = NSURLRequest(URL: nsurl!)
        widgetWebView.loadRequest(nsrequest)
        
        println("webview size \(widgetWebView.frame.size.width) \(widgetWebView.frame.size.height)")
        println("scrollview size \(widgetWebView.scrollView.frame.size.width) \(widgetWebView.scrollView.frame.size.height)")
    }

}