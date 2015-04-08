//
//  OpenHABViewController.swift
//  GLAD
//
//  Created by Matias Gualino on 2/4/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import UIKit

class OpenHABViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    var tracker : OpenHABTracker!
    
    @IBOutlet weak private var widgetTableView : UITableView!
    
    var genericWidgetCell : GenericUITableViewCell!
    var frameWidgetCell : FrameUITableViewCell!
    var switchWidgetCell : SwitchUITableViewCell!
    var setpointWidgetCell : SetpointUITableViewCell!
    var sliderWidgetCell : SliderUITableViewCell!
    var segmentedWidgetCell : SegmentedUITableViewCell!
    var rollershutterWidgetCell : RollershutterUITableViewCell!
    var selectionWidgetCell : SelectionUITableViewCell!
    var colorPickerWidgetCell : ColorPickerUITableViewCell!
    var imageWidgetCell : ImageUITableViewCell!
    var webWidgetCell : WebUITableViewCell!
    var videoWidgetCell : VideoUITableViewCell!
    var chartWidgetCell : ChartUITableViewCell!
    
    var pageUrl : String!
    var openHABRootUrl : String!
    var openHABUsername : String!
    var openHABPassword : String!
    var defaultSitemap : String!
    var ignoreSSLCertificate : Bool!
    var idleOff : Bool!
    var sitemaps : [OpenHABSitemap]!
    var currentPage : OpenHABSitemapPage!
    var selectionPicker : UIPickerView!
    var pageNetworkStatus : Reachability.NetworkStatus!
    var pageNetworkStatusAvailable : Bool!
    var toggle : Int!
    var deviceToken : String!
    var deviceId : String!
    var deviceName : String!
    var atmosphereTrackingId : String!
    
    func openHABTracked(openHABUrl: String!) {
        
    }
    func sendCommand(item: OpenHABItem, command: String) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("OpenHABViewController viewDidLoad")
        self.pageNetworkStatus = nil
        sitemaps = [OpenHABSitemap]()
        self.widgetTableView.tableFooterView = UIView()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didEnterBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }

    func loadSettings() {
        var prefs : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        self.openHABUsername = prefs.valueForKey("username") as? String
        self.openHABPassword = prefs.valueForKey("password") as? String
        self.ignoreSSLCertificate = prefs.boolForKey("ignoreSSL")
        self.defaultSitemap = prefs.valueForKey("defaultSitemap") as? String
        self.idleOff = prefs.boolForKey("idleOff")
        /*
        [[self appData] setOpenHABUsername:self.openHABUsername];
        [[self appData] setOpenHABPassword:self.openHABPassword];
        */
    }
    
    // Set SDImage (used for widget icons and images) authentication
    func setSDImageAuth() {
        var authStr = "\(openHABUsername):\(openHABPassword)"
        var authData = authStr.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        var authValue = "Basic \(authData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros))"
        var manager : SDWebImageDownloader = SDWebImageManager.sharedManager().imageDownloader
        manager.setValue(authValue, forHTTPHeaderField: "Authorization")
    }
    
    func sitemapByName(sitemapName: String) -> OpenHABSitemap? {
        for sitemap in sitemaps {
            if sitemap.name == sitemapName {
                return sitemap
            }
        }
        return nil
    }

    func pageNetworkStatusChanged() -> Bool {
        if self.pageUrl != nil {
            var pageReachability = Reachability.reachabilityWithUrlString(self.pageUrl)
            if !self.pageNetworkStatusAvailable {
                self.pageNetworkStatus = pageReachability.currentReachabilityStatus
                self.pageNetworkStatusAvailable = true
                return false
            } else {
                if self.pageNetworkStatus == pageReachability.currentReachabilityStatus {
                    return false
                } else {
                    self.pageNetworkStatus = pageReachability.currentReachabilityStatus
                    return true
                }
            }
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
