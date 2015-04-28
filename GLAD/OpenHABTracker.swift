//
//  OpenHABTracker.swift
//  GLAD
//
//  Created by Matias Gualino on 7/4/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import Foundation
import SystemConfiguration
import Darwin

protocol OpenHABTrackerDelegate {
    func openHABTrackingError(error : NSError)
    func openHABTrackingProgress(message: String)
    func openHABTracked(openHABUrl: String!)
    func openHABTrackingNetworkChange(networkStatus: Reachability.NetworkStatus)
}

class OpenHABTracker : NSObject, NSNetServiceDelegate, NSNetServiceBrowserDelegate {
    
    var openHABLocalUrl : String!
    var openHABRemoteUrl : String!
    var openHABDemoMode : Bool!
    var netService : NSNetService!
    var reach : Reachability!
    var oldReachabilityStatus : Reachability.NetworkStatus!
    var delegate : OpenHABTrackerDelegate!
    
    override init() {
        super.init()
        var prefs : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        openHABDemoMode = prefs.boolForKey("demomode")
        openHABLocalUrl = prefs.valueForKey("localUrl") as? String
        openHABRemoteUrl = prefs.valueForKey("remoteUrl") as? String
        openHABDemoMode = false
    }
    
    func startTracker() {
        // Check if any network is available
        if self.isNetworkConnected2() {
            // Check if demo mode is switched on in preferences
            if self.openHABDemoMode! {
                println("OpenHABTracker demo mode preference is on")
                self.trackedDemoMode()
            } else {
                // Check if network is WiFi. If not, go for remote URL
                if !self.isNetworkWiFi() {
                    println("OpenHABTracker network is not WiFi")
                    self.trackedRemoteUrl()
                    // If it is WiFi
                } else {
                    println("OpenHABTracker network is Wifi")
                    // Check if local URL is configured, if yes
                    if count(openHABLocalUrl) > 0 {
                        if self.isURLReachable(NSURL(string: openHABLocalUrl)!) {
                            self.trackedLocalUrl()
                        } else {
                            self.trackedRemoteUrl()
                        }
                        // If not, go for Bonjour discovery
                    } else {
                        self.startDiscovery()
                    }
                }
            }
        } else {
            if self.delegate != nil {
                var errorDetail : NSMutableDictionary = NSMutableDictionary()
                errorDetail.setValue("Network is not available.", forKey: NSLocalizedDescriptionKey)
                var trackingError = NSError(domain: "openHAB", code: 100, userInfo: errorDetail as [NSObject : AnyObject])
                self.delegate.openHABTrackingError(trackingError)
                self.reach = Reachability.reachabilityForInternetConnection()
                oldReachabilityStatus = reach.currentReachabilityStatus
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: ReachabilityChangedNotification, object: nil)
                self.reach.startNotifier()
            }
        }
    }
    
    func trackedLocalUrl() {
        if self.delegate != nil {
            self.delegate.openHABTrackingProgress("Connecting to local URL")
        }
        var openHABUrl : String = self.normalizeUrl(openHABLocalUrl)
        self.trackedUrl(openHABUrl)
    }
    
    func trackedRemoteUrl() {
        var openHABUrl : String = self.normalizeUrl(openHABRemoteUrl)
        if count(openHABUrl) > 0 {
        if self.delegate != nil {
            self.delegate.openHABTrackingProgress("Connecting to remote URL")
        }
        self.trackedUrl(openHABUrl)
        } else {
            if self.delegate != nil {
                var errorDetail : NSMutableDictionary = NSMutableDictionary()
                errorDetail.setValue("Remote URL is not configured.", forKey: NSLocalizedDescriptionKey)
                var trackingError = NSError(domain: "openHAB", code: 101, userInfo: errorDetail as [NSObject : AnyObject])
                self.delegate.openHABTrackingError(trackingError)
            }
        }
    }
    
    func trackedDiscoveryUrl(discoveryUrl: String) {
        if self.delegate != nil {
                self.delegate.openHABTrackingProgress("Connecting to discovered URL")
        }
        self.trackedUrl(discoveryUrl)
    }
    
    func trackedDemoMode() {
        if self.delegate != nil {
            self.delegate.openHABTrackingProgress("Running in demo mode. Check settings to disable demo mode.")
        }
        self.trackedUrl("http://demo.openhab.org:8080")
    }
    
    func trackedUrl(trackedUrl: String) {
        if self.delegate != nil {
            self.delegate.openHABTracked(trackedUrl)
        }
    }
    
    func reachabilityChanged(notification: NSNotification) {
        var changedReach : Reachability? = notification.object as? Reachability
        if changedReach != nil {
            var nStatus : Reachability.NetworkStatus = changedReach!.currentReachabilityStatus
            if nStatus != oldReachabilityStatus {
                println("Network status changed from \(self.stringFromStatus(oldReachabilityStatus)) to \(self.stringFromStatus(nStatus))")
                oldReachabilityStatus = nStatus
                if self.delegate != nil {
                    self.delegate.openHABTrackingNetworkChange(nStatus)
                }
            }
        }
    }
    
    func startDiscovery() {
        println("OpenHABTracking starting Bonjour discovery")
        if self.delegate != nil {
            self.delegate.openHABTrackingProgress("Discovering openHAB")
        }
        netService = NSNetService(domain: "local.", type: "_openhab-server-ssl._tcp.", name: "openHAB-ssl")
        netService.delegate = self
        netService.resolveWithTimeout(5.0)
    }
    
    // NSNetService delegate methods for Bonjour resolving
    func netServiceDidResolveAddress(resolvedNetService: NSNetService) {
        if resolvedNetService.addresses != nil {
            var dataAddress : NSData? = resolvedNetService.addresses![0] as? NSData
            if dataAddress != nil {
                println("OpenHABTracker discovered \(self.getStringIpFromAddressData(dataAddress!)):\(resolvedNetService.port)")
                var openhabUrl : String = "https://\(self.getStringIpFromAddressData(dataAddress!)):\(resolvedNetService.port)"
                self.trackedDiscoveryUrl(openhabUrl)
            }
        }
    }
    
    func netService(netService: NSNetService, errorDict: NSDictionary) {
        println("OpenHABTracker discovery didn't resolve openHAB")
        self.trackedRemoteUrl()
    }
    
    func normalizeUrl(url: String) -> String {
        var urlAux : NSString = url as NSString
        if urlAux.hasSuffix("/") {
            urlAux = urlAux.substringToIndex(urlAux.length - 1)
        }
        return urlAux as String
    }
    
    func validateUrl(url: String) -> Bool {
        var theURL : String = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        var urlTest : NSPredicate = NSPredicate(format: "SELF MATCHES %@", theURL)
        return urlTest.evaluateWithObject(url)
    }
    
    func isNetworkConnected2() -> Bool {
        var networkReach :Reachability = Reachability.reachabilityForInternetConnection()
        let networkReachabilityStatus : Reachability.NetworkStatus = networkReach.currentReachabilityStatus
        println("Network status = \(networkReachabilityStatus)")
        if networkReachabilityStatus == Reachability.NetworkStatus.ReachableViaWiFi || networkReachabilityStatus == Reachability.NetworkStatus.ReachableViaWWAN {
            return true
        }
        return false
    }
    
    func isNetworkWiFi() -> Bool {
        let wifiReach : Reachability = Reachability.reachabilityForInternetConnection()
        let wifiReachabilityStatus : Reachability.NetworkStatus = wifiReach.currentReachabilityStatus
        if wifiReachabilityStatus == Reachability.NetworkStatus.ReachableViaWiFi {
            return true
        }
        return false
    }
    
    func isURLReachable(url : NSURL) -> Bool {
        var port = String(format:"%d", url.port!)
        var client : FastSocket = FastSocket(host: url.host!, andPort: port)
        println("Checking if \(url.host):\(port) is reachable")
        if client.connect(1) {
            client.close()
            return true
        } else {
            return false
        }
    }
    
    func stringFromStatus(status: Reachability.NetworkStatus) -> String? {
        var string : String? = nil
        switch status {
        case Reachability.NetworkStatus.NotReachable:
            string = "unreachable"
        case Reachability.NetworkStatus.ReachableViaWiFi:
            string = "WiFi"
        case Reachability.NetworkStatus.ReachableViaWWAN:
            string = "WWAN"
        default:
            string = "Unknown"
        }
        return string
    }
    
    func getStringIpFromAddressData(dataIn: NSData) -> String? {
        var ipString : String? = nil
        let ptr = UnsafePointer<sockaddr_in>(dataIn.bytes)
        ipString = "\(inet_ntoa(ptr.memory.sin_addr))"
        return ipString
    }
    
    
}