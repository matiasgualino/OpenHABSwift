//
//  OpenHABSelectSitemapViewController.swift
//  GLAD
//
//  Created by Matias Gualino on 9/4/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import UIKit
import Alamofire

class OpenHABSelectSitemapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak private var tableView : UITableView!
    var sitemaps : [OpenHABSitemap]!
    var openHABRootUrl : String!
    var openHABUsername : String!
    var openHABPassword : String!
    var ignoreSSLCertificate : Bool!
    var selectedSitemap : Int!
   
    init() {
        super.init(nibName: "OpenHABSelectSitemapViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("OpenHABSelectSitemapViewController viewDidLoad")
        if self.sitemaps != nil {
            println("We have sitemap list here!")
        }
        self.tableView.tableFooterView = UIView()
        self.sitemaps = [OpenHABSitemap]()
        var prefs : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        self.openHABUsername = prefs.valueForKey("username") as? String
        self.openHABPassword = prefs.valueForKey("password") as? String
		self.openHABRootUrl = prefs.valueForKey("remoteUrl") as? String
        self.ignoreSSLCertificate = prefs.boolForKey("ignoreSSL")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sitemaps.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var CellIdentifier = "SelectSitemapCell"
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath:indexPath) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier:CellIdentifier)
        }
        var sitemap : OpenHABSitemap = sitemaps[indexPath.row]
        if sitemap.label != nil {
            cell!.textLabel?.text = sitemap.label
        } else {
            cell!.textLabel?.text = sitemap.name
        }
        if sitemap.icon != nil {
            var iconUrlString : String = "\(self.openHABRootUrl)/images/\(sitemap.icon).png"
            println("icon url = \(iconUrlString)")
            let url = NSURL(string: iconUrlString)
            let data = NSData(contentsOfURL: url!)
            cell!.imageView?.image = UIImage(data: data!)
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Selected sitemap \(indexPath.row)")
        var sitemap : OpenHABSitemap = sitemaps[indexPath.row]
        var prefs : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        prefs.setValue(sitemap.name, forKey: "defaultSitemap")
        selectedSitemap = indexPath.row
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var sitemapsUrlString : String = "\(self.openHABRootUrl)/rest/sitemaps"
        var sitemapsUrl : NSURL? = NSURL(string: sitemapsUrlString)
        var sitemapsRequest : NSMutableURLRequest = NSMutableURLRequest(URL: sitemapsUrl!)
        sitemapsRequest.setAuthCredentials(self.openHABUsername, password:self.openHABPassword)
        
        Alamofire.request(sitemapsRequest).response({
            (_, response, data, error) in
            
            if error != nil {
                println("Error:------> \(error!.description)")
                println("Error Code:------> \(response?.statusCode)")
            } else {
                self.sitemaps.removeAll(keepCapacity: false)
                println("Sitemap response")
                println("openHAB 1")
                var error : NSErrorPointer = NSErrorPointer()
                var doc : GDataXMLDocument? = GDataXMLDocument(data: data! as! NSData, error: error)
                if doc == nil {
                    return
                }
                println(doc!.rootElement().name())
                if doc!.rootElement().name() == "sitemaps" {
                    for element in doc!.rootElement().elementsForName("sitemap") {
                        var sitemap : OpenHABSitemap = OpenHABSitemap.initWithXML((element as? GDataXMLElement)!)
                        self.sitemaps.append(sitemap)
                    }
                } else {
                    return
                }
                self.tableView.reloadData()
            }
        })
    }
}
