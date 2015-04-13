//
//  OpenHABViewController.swift
//  GLAD
//
//  Created by Matias Gualino on 2/4/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import UIKit
import Alamofire


class OpenHABViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, OpenHABSitemapPageDelegate, OpenHABTrackerDelegate {

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
    var selectedWidgetRow : Int!
    
    override init() {
        super.init(nibName: "OpenHABViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func openHABTracked(openHABUrl: String!) {
        println("OpenHABViewController openHAB URL = \(openHABUrl)")
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.openHABRootUrl = openHABUrl
        // Checking openHAB version
/* TOOD : CHECK VERSION        var pageToLoadUrl : NSURL? = NSURL(string: "\(self.openHABRootUrl)/rest/bindings")
        var pageRequest : NSMutableURLRequest = NSMutableURLRequest(URL: pageToLoadUrl!)
        pageRequest.setAuthCredentials(self.openHABUsername, password: self.openHABPassword)
        pageRequest.timeoutInterval = 25.0
        
        
        [versionPageOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"This is an openHAB 2.X");
        [[self appData] setOpenHABVersion:2];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSData *response = (NSData*)responseObject;
        NSError *error;
        [self selectSitemap];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"This is an openHAB 1.X");
        [[self appData] setOpenHABVersion:1];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"Error:------>%@", [error description]);
        NSLog(@"error code %ld",(long)[operation.response statusCode]);
        [self selectSitemap];
        }];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [versionPageOperation start];
        
        */

        self.selectSitemap()
        
    }
    
    func openHABTrackingProgress(message: String) {
        println("OpenHABViewController \(message)")
        TSMessage.showNotificationInViewController(self.navigationController, title: "Connecting", subtitle: message, image: nil, type: TSMessageNotificationType.Message, duration: 3.0, callback: nil, buttonTitle: nil, buttonCallback: nil, atPosition: TSMessageNotificationPosition.Bottom, canBeDismissedByUser: true)
    }
    
    func openHABTrackingError(error : NSError) {
        println("OpenHABViewController discovery error")
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        TSMessage.showNotificationInViewController(self.navigationController, title: "Error", subtitle: error.localizedDescription, image: nil, type: TSMessageNotificationType.Error, duration: 60.0, callback: nil, buttonTitle: nil, buttonCallback: nil, atPosition: TSMessageNotificationPosition.Bottom, canBeDismissedByUser: true)
    }
    
    func sendCommand(item: OpenHABItem, command: String) {
        var commandUrl : NSURL = NSURL(string: item.link)!
        var commandRequest : NSMutableURLRequest = NSMutableURLRequest(URL: commandUrl)
        commandRequest.HTTPMethod = "POST"
        commandRequest.HTTPBody = command.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        commandRequest.setAuthCredentials(self.openHABUsername, password: self.openHABPassword)
        commandRequest.setValue("text/plain", forHTTPHeaderField: "Content-type")

        Alamofire.request(commandRequest).response { (request, response, data, error) -> Void in
            println("COMANDO ENVIADO")
            println(request)
            println(response)
            println(data)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("OpenHABViewController viewDidLoad")
        self.pageNetworkStatus = nil
        sitemaps = [OpenHABSitemap]()
        self.widgetTableView.delegate = self
        self.widgetTableView.dataSource = self
        var backgroundImageView = UIImageView(frame: self.widgetTableView.frame)
        backgroundImageView.image = UIImage(named:"background")
        backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.widgetTableView.backgroundView = backgroundImageView
        self.widgetTableView.tableFooterView = UIView()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didEnterBackground:", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didBecomeActive:", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        println("OpenHABViewController viewWillAppear")
        super.viewWillAppear(animated)
        // Load settings into local properties
        self.loadSettings()
        // Set authentication parameters to SDImage
        self.setSDImageAuth()
        // Set default controller for TSMessage to self
        TSMessage.setDefaultViewController(self.navigationController)
        registerTableViewIdentifiers()
        // Disable idle timeout if configured in settings
        if self.idleOff != nil {
            UIApplication.sharedApplication().idleTimerDisabled = true
        }
        self.doRegisterApps()
        // if pageUrl = nil it means we are the first opened OpenHABViewController
        if pageUrl == nil {
            // Set self as root view controller
            // Add self as observer for APS registration
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleApsRegistration:", name: "apsRegistered", object: nil)
            if self.currentPage != nil {
                self.currentPage.widgets.removeAll(keepCapacity: false)
                self.widgetTableView.reloadData()
            }
            println("OpenHABViewController pageUrl is empty, this is first launch")
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            tracker = OpenHABTracker()
            tracker.delegate = self
            tracker.startTracker()
        } else {
            if !self.pageNetworkStatusChanged() {
                println("OpenHABViewController pageUrl = \(pageUrl), loading page");
                self.loadPage(false)
            } else {
                println("OpenHABViewController network status changed while I was not appearing")
                self.restart()
            }
        }
    }
    
    func handleApsRegistration(note: NSNotification) {
        println("handleApsRegistration")
        var theData : [NSObject : AnyObject]? = note.userInfo
        if theData != nil {
            self.deviceId = theData!["deviceId"] as? String
            self.deviceToken = theData!["deviceToken"] as? String
            self.deviceName = theData!["deviceName"] as? String
            self.doRegisterApps()
        }
    }
    
    func doRegisterApps() {
        var prefs : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if prefs.stringForKey("remoteUrl") == "https://my.openhab.org" {
            if deviceId != nil && deviceToken != nil && deviceName != nil {
                println("Registering with my.openHAB")
                var registrationUrlString : String = "https://my.openhab.org/addAppleRegistration?regId=\(deviceToken)&deviceId=\(deviceId)&deviceModel=\(deviceName)"
                var registrationUrl : NSURL? = NSURL(string: registrationUrlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
                println("Registration URL = \(registrationUrl!.absoluteString)")
                var registrationRequest : NSMutableURLRequest? = NSMutableURLRequest(URL: registrationUrl!)
                registrationRequest?.setAuthCredentials(self.openHABUsername, password: self.openHABPassword)

                Alamofire.request(registrationRequest!).response({
                    (_, response, data, error) in
                    
                    if error != nil {
                        println("my.openHAB registration failed")
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        println("Error:------> \(error!.description)")
                        println("Error Code:------> \(response?.statusCode)")
                    } else {
                        println("my.openHAB registration sent")
                    }
                })
            }
        }
    }
    
    func didEnterBackground(notification: NSNotification) {
        println("OpenHABViewController didEnterBackground")
        UIApplication.sharedApplication().idleTimerDisabled = false
    }
    
    func didBecomeActive(notification: NSNotification) {
        println("OpenHABViewController didBecomeActive")
        // re disable idle off timer
        if self.idleOff! {
            UIApplication.sharedApplication().idleTimerDisabled = true
        }
        if self.isViewLoaded() && self.view.window != nil && self.pageUrl != nil {
            if !self.pageNetworkStatusChanged() {
                println("OpenHABViewController isViewLoaded, restarting network activity")
                self.loadPage(false)
            } else {
                println("OpenHABViewController network status changed while i was inactive")
                self.restart()
            }
        }
    }
    
    func restart() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func registerTableViewIdentifiers() {
        var genericWidgetCellNib = UINib(nibName: "GenericUITableViewCell", bundle: nil)
        self.widgetTableView.registerNib(genericWidgetCellNib, forCellReuseIdentifier: "genericWidgetCell")
        
        var frameWidgetCellNib = UINib(nibName: "FrameUITableViewCell", bundle: nil)
        self.widgetTableView.registerNib(frameWidgetCellNib, forCellReuseIdentifier: "frameWidgetCell")
        
        var switchWidgetCellNib = UINib(nibName: "SwitchUITableViewCell", bundle: nil)
        self.widgetTableView.registerNib(switchWidgetCellNib, forCellReuseIdentifier: "switchWidgetCell")
        
        var setpointWidgetCellNib = UINib(nibName: "SetpointUITableViewCell", bundle: nil)
        self.widgetTableView.registerNib(setpointWidgetCellNib, forCellReuseIdentifier: "setpointWidgetCell")
        
        var sliderWidgetCellNib = UINib(nibName: "SliderUITableViewCell", bundle: nil)
        self.widgetTableView.registerNib(sliderWidgetCellNib, forCellReuseIdentifier: "sliderWidgetCell")
        
        var segmentedWidgetCellNib = UINib(nibName: "SegmentedUITableViewCell", bundle: nil)
        self.widgetTableView.registerNib(segmentedWidgetCellNib, forCellReuseIdentifier: "segmentedWidgetCell")
        
        var rollershutterWidgetCellNib = UINib(nibName: "RollershutterUITableViewCell", bundle: nil)
        self.widgetTableView.registerNib(rollershutterWidgetCellNib, forCellReuseIdentifier: "rollershutterWidgetCell")
        
        var selectionWidgetCellNib = UINib(nibName: "SelectionUITableViewCell", bundle: nil)
        self.widgetTableView.registerNib(selectionWidgetCellNib, forCellReuseIdentifier: "selectionWidgetCell")
        
        var colorPickerWidgetCellNib = UINib(nibName: "ColorPickerUITableViewCell", bundle: nil)
        self.widgetTableView.registerNib(colorPickerWidgetCellNib, forCellReuseIdentifier: "colorPickerWidgetCell")
        
        var imageWidgetCellNib = UINib(nibName: "ImageUITableViewCell", bundle: nil)
        self.widgetTableView.registerNib(imageWidgetCellNib, forCellReuseIdentifier: "imageWidgetCell")
        
        var webWidgetCellNib = UINib(nibName: "WebUITableViewCell", bundle: nil)
        self.widgetTableView.registerNib(webWidgetCellNib, forCellReuseIdentifier: "webWidgetCell")
        
        var videoWidgetCellNib = UINib(nibName: "VideoUITableViewCell", bundle: nil)
        self.widgetTableView.registerNib(videoWidgetCellNib, forCellReuseIdentifier: "videoWidgetCell")
        
        var chartWidgetCellNib = UINib(nibName: "ChartUITableViewCell", bundle: nil)
        self.widgetTableView.registerNib(chartWidgetCellNib, forCellReuseIdentifier: "chartWidgetCell")
    }
    
   
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.currentPage != nil {
            return self.currentPage.widgets.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var widget : OpenHABWidget = self.currentPage.widgets[indexPath.row]
        switch widget.type {
            case "Frame":
                return widget.label.utf16Count > 0 ? 35 : 0
            case "Video":
                return self.widgetTableView.frame.size.width/1.33333333
            case "Image":
                return widget.image != nil ? widget.image.size.height/(widget.image.size.width/self.widgetTableView.frame.size.width) : 44
            case "Chart":
                return widget.image != nil ? widget.image.size.height/(widget.image.size.width/self.widgetTableView.frame.size.width) : 44
            case "Webview":
                return widget.height != nil ?
                     CGFloat((widget.height! as NSString).floatValue*44) : 44*8
            default:
                return 44
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var widget : OpenHABWidget = self.currentPage.widgets[indexPath.row]
        var cellIdentifier : String = "genericWidgetCell"
        if widget.type == "Frame" {
            cellIdentifier = "frameWidgetCell"
        } else if widget.type == "Switch" {
            if widget.mappings.count > 0 {
                cellIdentifier = "segmentedWidgetCell"
            } else if widget.item.type == "RollershutterItem" {
                cellIdentifier = "rollershutterWidgetCell"
            } else {
                cellIdentifier = "switchWidgetCell"
            }
        } else if widget.type == "Setpoint" {
            cellIdentifier = "setpointWidgetCell"
        } else if widget.type == "Slider" {
            cellIdentifier = "sliderWidgetCell"
        } else if widget.type == "Selection" {
            cellIdentifier = "selectionWidgetCell"
        } else if widget.type == "Colorpicker" {
            cellIdentifier = "colorPickerWidgetCell"
        } else if widget.type == "Chart" {
            cellIdentifier = "chartWidgetCell"
        } else if widget.type == "Image" {
            cellIdentifier = "imageWidgetCell"
        } else if widget.type == "Video" {
            cellIdentifier = "videoWidgetCell"
        } else if widget.type == "Webview" {
            cellIdentifier = "webWidgetCell"
        }

        var cell : GenericUITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as GenericUITableViewCell
        // No icon is needed for image, video, frame and web widgets
        if widget.icon != nil && cellIdentifier != "chartWidgetCell" || cellIdentifier == "imageWidgetCell" || cellIdentifier == "videoWidgetCell" || cellIdentifier == "frameWidgetCell" || cellIdentifier == "webWidgetCell" {
            var iconUrlString = "\(self.openHABRootUrl)/images/\(widget.icon).png"
            cell.imageView?.sd_setImageWithURL(NSURL(string: iconUrlString), placeholderImage: UIImage(named: "blankicon.png"), options: SDWebImageOptions.allZeros)
        }
        if cellIdentifier == "colorPickerWidgetCell" {
            (cell as ColorPickerUITableViewCell).callbackPressColorButton = ({
                (colorPickerUITableViewCell: ColorPickerUITableViewCell) -> Void in

                var colorPickerViewController = ColorPickerViewController()
                colorPickerViewController.widget = self.currentPage.widgets[self.widgetTableView.indexPathForCell(cell)!.row]
                self.navigationController?.pushViewController(colorPickerViewController, animated: true)
            })
        }
        if cellIdentifier == "chartWidgetCell" {
            (cell as ChartUITableViewCell).baseUrl = self.openHABRootUrl
        }
        if cellIdentifier == "chartWidgetCell" || cellIdentifier == "imageWidgetCell" {
            (cell as ImageUITableViewCell).callbackDidLoadImage = ({
                () -> Void in
                self.widgetTableView.reloadData()
            })
        }
        cell.loadWidget(widget)
        cell.displayWidget()
        // Check if this is not the last row in the widgets list
        if indexPath.row < currentPage.widgets.count - 1 {
            var nextWidget : OpenHABWidget = currentPage.widgets[indexPath.row + 1]
            if nextWidget.type == "Frame" || nextWidget.type == "Image" || nextWidget.type == "Video" || nextWidget.type == "Webview" || nextWidget.type == "Chart" {
                cell.separatorInset = UIEdgeInsetsZero
            } else if widget.type != "Frame" {
                cell.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0)
            }
        }
        
        self.widgetTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        let posX = cell.imageView != nil ? cell.imageView!.frame.width : 50
        var separatorView : UIView = UIView(frame: CGRectMake(50, cell.frame.height - 1, cell.frame.size.width, 1))
        
        if cellIdentifier == "frameWidgetCell" {
            separatorView = UIView(frame: CGRectMake(50, 0, cell.frame.size.width, 2))
        }
        
        separatorView.backgroundColor = UIColor.whiteColor()
        cell.contentView.addSubview(separatorView)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var widget : OpenHABWidget = currentPage.widgets[indexPath.row]
        if widget.linkedPage != nil {
            println("Selected \(widget.linkedPage.link)")
            selectedWidgetRow = indexPath.row
            var newViewController : OpenHABViewController = OpenHABViewController()
            newViewController.pageUrl = widget.linkedPage.link
            newViewController.openHABRootUrl = self.openHABRootUrl
            self.navigationController?.pushViewController(newViewController, animated: true)
        } else if widget.type == "Selection" {
            println("Selected selection widget")
            selectedWidgetRow = indexPath.row
            var selectionViewController : OpenHABSelectionTableViewController = OpenHABSelectionTableViewController()
            var selectedWidget : OpenHABWidget = self.currentPage.widgets[selectedWidgetRow]
            selectionViewController.mappings = selectedWidget.mappings
            selectionViewController.selectionItemCallback = {
                (selectedMappingIndex: Int) -> Void in
                var selectedWidget : OpenHABWidget = self.currentPage.widgets[self.selectedWidgetRow]
                var selectedMapping : OpenHABWidgetMapping = selectedWidget.mappings![selectedMappingIndex]
                self.sendCommand(selectedWidget.item, command: selectedMapping.command)
            }
            selectionViewController.selectionItem = selectedWidget.item
            self.navigationController?.pushViewController(selectionViewController, animated: true)
        }
        self.widgetTableView.deselectRowAtIndexPath(self.widgetTableView.indexPathForSelectedRow()!, animated: true)
    }
    
    func loadPage(longPolling: Bool) {
        if self.pageUrl == nil {
            return
        }
        println("pageUrl = \(self.pageUrl)")
        if !longPolling {
            self.pageNetworkStatusChanged()
        }
        
        var pageToLoadUrl : NSURL = NSURL(string:self.pageUrl)!
        var pageRequest : NSMutableURLRequest = NSMutableURLRequest(URL: pageToLoadUrl)
        pageRequest.setAuthCredentials(self.openHABUsername, password: self.openHABPassword)
        pageRequest.setValue("application/xml", forHTTPHeaderField: "Accept")
        pageRequest.setValue("1.0", forHTTPHeaderField: "X-Atmosphere-Framework")

        if longPolling {
            println("long polling, so setting atmosphere transport")
            pageRequest.setValue("long-polling", forHTTPHeaderField: "X-Atmosphere-Transport")
            pageRequest.timeoutInterval = 100.0
        } else {
            self.atmosphereTrackingId = nil
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            pageRequest.timeoutInterval = 25.0
        }

        if self.atmosphereTrackingId != nil {
            pageRequest.setValue(self.atmosphereTrackingId, forHTTPHeaderField: "X-Atmosphere-tracking-id")
        } else {
            pageRequest.setValue("0", forHTTPHeaderField: "X-Atmosphere-tracking-id")
        }

        Alamofire.request(pageRequest).response({
            (_, response, data, error) in
            
            if error != nil {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                println("Error:------> \(error!.description)")
                println("Error Code:------> \(response?.statusCode)")
                self.atmosphereTrackingId = nil
                if error!.code == -1001 && longPolling {
                    println("Timeout, restarting requests")
                    self.loadPage(false)
                } else if error!.code == -999 {
                    // Request was cancelled
                    println("Request was cancelled")
                } else {
                    // Error
                    if error!.code == -1012 {
                        TSMessage.showNotificationInViewController(self.navigationController, title: "Error", subtitle: "SSL Certificate Error", image: nil, type: TSMessageNotificationType.Error, duration: 5.0, callback: nil, buttonTitle: nil, buttonCallback: nil, atPosition: TSMessageNotificationPosition.Bottom, canBeDismissedByUser: true)
                    } else {
                        TSMessage.showNotificationInViewController(self.navigationController, title: "Error", subtitle: error!.localizedDescription, image: nil, type: TSMessageNotificationType.Error, duration: 5.0, callback: nil, buttonTitle: nil, buttonCallback: nil, atPosition: TSMessageNotificationPosition.Bottom, canBeDismissedByUser: true)
                    }
                    println("Request failed: \(error!.localizedDescription)")
                }
            } else {
                println("Page loaded with success")
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                var headers : [NSObject : AnyObject] = response!.allHeaderFields
                
                if headers["X-Atmosphere-tracking-id"] != nil {
                    let trackId = headers["X-Atmosphere-tracking-id"] as? String
                    println("Found X-Atmosphere-tracking-id: \(trackId)")
                    self.atmosphereTrackingId = trackId
                }
                if data != nil {
                    var error : NSErrorPointer = NSErrorPointer()
                    var doc : GDataXMLDocument? = GDataXMLDocument(data: data! as NSData, error: error)
                    if doc == nil {
                        return
                    }
                    
                    println(doc!.rootElement().stringValue())
                    
                    println(doc!.rootElement().name())
                    if (doc!.rootElement().name() == "page") {
                        self.currentPage = OpenHABSitemapPage.initWithXML(doc!.rootElement())
                    } else {
                        println("Unable to find page root element")
                        return
                    }
                    
                    self.currentPage.delegate = self
                    self.widgetTableView.reloadData()
                    self.navigationItem.title = self.currentPage.title.componentsSeparatedByString("[")[0]
                    if longPolling {
                        self.loadPage(false)
                    } else {
                        self.loadPage(true)
                    }
                    
                } else {
                    return
                }
            }
            
        })
        
    }
    
    func selectSitemap() {
        var sitemapsUrlString = "\(self.openHABRootUrl)/rest/sitemaps"
        var sitemapsUrl = NSURL(string: sitemapsUrlString)
        var sitemapsRequest = NSMutableURLRequest(URL: sitemapsUrl!)
        sitemapsRequest.setAuthCredentials(self.openHABUsername, password: self.openHABPassword)
        sitemapsRequest.timeoutInterval = 25.0
        Alamofire.request(sitemapsRequest).response({
            (_, response, data, error) in
            
            if error != nil {
                // TODO : Block para failure
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                println("Error:------> \(error!.description)")
                println("Error Code:------> \(response?.statusCode)")
                // Error
                if error!.code == -1012 {
                    TSMessage.showNotificationInViewController(self.navigationController, title: "Error", subtitle: "SSL Certificate Error", image: nil, type: TSMessageNotificationType.Error, duration: 5.0, callback: nil, buttonTitle: nil, buttonCallback: nil, atPosition: TSMessageNotificationPosition.Bottom, canBeDismissedByUser: true)
                } else {
                    TSMessage.showNotificationInViewController(self.navigationController, title: "Error", subtitle: error!.localizedDescription, image: nil, type: TSMessageNotificationType.Error, duration: 5.0, callback: nil, buttonTitle: nil, buttonCallback: nil, atPosition: TSMessageNotificationPosition.Bottom, canBeDismissedByUser: true)
                }
            } else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.sitemaps.removeAll(keepCapacity: false)
                if data != nil {
                    var error : NSErrorPointer = NSErrorPointer()
                    println(NSString(data: data as NSData, encoding: NSUTF8StringEncoding))
                    var doc : GDataXMLDocument? = GDataXMLDocument(data: data! as NSData, error: error)
                    if doc == nil {
                        return
                    }
                    println(doc?.rootElement().name())
                    if doc?.rootElement().name() == "sitemaps" {
                        for element in doc!.rootElement().elementsForName("sitemap") {
                            var sitemap : OpenHABSitemap = OpenHABSitemap.initWithXML(element as GDataXMLElement)
                            self.sitemaps.append(sitemap)
                        }
                    }
                    
                    // TODO                    [[self appData] setSitemaps:sitemaps];
                    if self.sitemaps.count > 0 {
                        if self.sitemaps.count > 1 {
                            if self.defaultSitemap != nil {
                                var sitemapToOpen : OpenHABSitemap? = self.sitemapByName(self.defaultSitemap)
                                if sitemapToOpen != nil {
                                    self.pageUrl = sitemapToOpen!.homepageLink
                                    self.loadPage(false)
                                } else {
                                    self.navigationController?.pushViewController(OpenHABSelectSitemapViewController(), animated: true)
                                }
                            } else {
                                self.navigationController?.pushViewController(OpenHABSelectSitemapViewController(), animated: true)
                            }
                        } else {
                            self.pageUrl = self.sitemaps[0].homepageLink
                            self.loadPage(false)
                        }
                    } else {
                        TSMessage.showNotificationInViewController(self.navigationController, title: "Error", subtitle: "openHAB returned empty sitemap list", image: nil, type: TSMessageNotificationType.Error, duration: 5.0, callback: nil, buttonTitle: nil, buttonCallback: nil, atPosition: TSMessageNotificationPosition.Bottom, canBeDismissedByUser: true)
                    }
                } else {
                    return
                }
            }
        })
        
        println("Firing request")
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func loadSettings() {
        var prefs : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        self.openHABUsername = prefs.valueForKey("username") as? String
        self.openHABPassword = prefs.valueForKey("password") as? String
        self.ignoreSSLCertificate = prefs.boolForKey("ignoreSSL")
        self.defaultSitemap = prefs.valueForKey("defaultSitemap") as? String
        self.idleOff = prefs.boolForKey("idleOff")
        /*
        [[self appData] setOpenHABUsername:self.openHABUsername]
        [[self appData] setOpenHABPassword:self.openHABPassword]
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
            if self.pageNetworkStatusAvailable == nil || !self.pageNetworkStatusAvailable! {
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

    
    func openHABTrackingNetworkChange(networkStatus: Reachability.NetworkStatus) {
        
    }
}
