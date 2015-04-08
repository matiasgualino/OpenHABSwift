//
//  Reachability+URL.swift
//  GLAD
//
//  Created by Matias Gualino on 8/4/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import Foundation

extension Reachability {
    class func reachabilityWithUrlString(urlString: String) -> Reachability {
        var url = NSURL(string: urlString)
        return self.reachabilityWithUrl(url!)
    }

    class func reachabilityWithUrl(url: NSURL) -> Reachability {
        return Reachability(hostname: url.host!)
    }
    
    func currentlyReachable() -> Bool {
        var status = self.currentReachabilityStatus
        if status == Reachability.NetworkStatus.ReachableViaWiFi || status == Reachability.NetworkStatus.ReachableViaWWAN {
            return true
        } else {
            return false
        }
    }
    
}