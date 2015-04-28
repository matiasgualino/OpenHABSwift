//
//  OpenHABItem.swift
//  GLAD
//
//  Created by Matias Gualino on 28/3/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

class OpenHABItem : NSObject {
    var type : String!
    var name : String!
    var state : String!
    var link : String!
    
    override init() {}
    
    func stateAsUIColor() -> UIColor {
        if state == "Uninitialized" {
            return UIColor(hue: 0.0, saturation: 0.0, brightness: 0.0, alpha: 1.0)
        } else {
            var values = (self.state as NSString).componentsSeparatedByString(",")
            if values.count == 3 {
                var hue : CGFloat = CGFloat((values[0] as! NSString).floatValue / 360.0)
                var saturation : CGFloat = CGFloat((values[1] as! NSString).floatValue / 100.0)
                var brightness : CGFloat = CGFloat((values[2] as! NSString).floatValue / 100.0)
                return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
            } else {
                return UIColor(hue: 0.0, saturation: 0.0, brightness: 0.0, alpha: 1.0)
            }
        }
    }
    
    func stateAsFloat() -> Float
    {
        return (state as NSString).floatValue
    }
    
    func stateAsInt() -> Int
    {
        return (state as NSString).integerValue
    }
    
    class func initWithDictionary(dictionary: NSDictionary) -> OpenHABItem {
        var item = OpenHABItem()
        for key in dictionary.allKeys {
            let keyStr = (key as? String)
            if keyStr == "type" {
                item.type = dictionary.valueForKey(keyStr!) as? String
            } else if keyStr == "name" {
                item.name = dictionary.valueForKey(keyStr!) as? String
            } else if keyStr == "state" {
                item.state = dictionary.valueForKey(keyStr!) as? String
            } else if keyStr == "link" {
                item.link = dictionary.valueForKey(keyStr!) as? String
            }
        }
        return item
    }
    
    class func initWithXML(xmlElement: GDataXMLElement) -> OpenHABItem {
        var item = OpenHABItem()
        for child in xmlElement.children() {
            let childElement = child as? GDataXMLElement
            if childElement != nil {
                if childElement!.name() == "type" {
                    item.type = childElement!.stringValue()
                } else if childElement!.name() == "name" {
                    item.name = childElement!.stringValue()
                } else if childElement!.name() == "state" {
                    item.state = childElement!.stringValue()
                } else if childElement!.name() == "link" {
                    item.link = childElement!.stringValue()
                }
            }
        }
        return item
    }
    
}