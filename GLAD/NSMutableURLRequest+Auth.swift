//
//  NSMutableURLRequest+Auth.swift
//  GLAD
//
//  Created by Matias Gualino on 9/4/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import Foundation

extension NSMutableURLRequest {
    func setAuthCredentials(username: String, password: String) {
        var authStr = "\(username):\(password)"
        var authData = authStr.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        var authValue = "Basic \(authData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros))"
        self.setValue(authValue, forHTTPHeaderField: "Authorization")
    }
}