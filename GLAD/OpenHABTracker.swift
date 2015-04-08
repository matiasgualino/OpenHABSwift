//
//  OpenHABTracker.swift
//  GLAD
//
//  Created by Matias Gualino on 7/4/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import Foundation

class OpenHABTracker : NSObject, NSNetServiceDelegate, NSNetServiceBrowserDelegate {
    
    var openHABLocalUrl : String!
    var openHABRemoteUrl : String!
    var openHABDemoMode : Bool!
    var netService : NSNetService!
    var reach : Reachability!
    var oldReachabilityStatus : Reachability.NetworkStatus!
    
}