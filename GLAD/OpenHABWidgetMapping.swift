//
//  OpenHABWidgetMapping.swift
//  GLAD
//
//  Created by Matias Gualino on 28/3/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import Foundation

class OpenHABWidgetMapping {
    var command : String!
    var label : String!
    
    class func initWithXML(xmlElement: GDataXMLElement) -> OpenHABWidgetMapping {
        var openHABWidgetMapping = OpenHABWidgetMapping()
        for child in xmlElement.children() {
            let childElement = child as? GDataXMLElement
            if childElement != nil {
                if childElement!.name() == "command" {
                    openHABWidgetMapping.command = childElement!.stringValue()
                } else if childElement!.name() == "label" {
                    openHABWidgetMapping.label = childElement!.stringValue()
                }
            }
        }
        return openHABWidgetMapping
    }
    
    class func initWithDictionary(dictionary: NSDictionary) -> OpenHABWidgetMapping {
        var openHABWidgetMapping = OpenHABWidgetMapping()
        for key in dictionary.allKeys {
            let keyStr = key as? String
            if keyStr != nil {
                if keyStr == "command" {
                    openHABWidgetMapping.command = dictionary.valueForKey(keyStr!) as? String
                } else if keyStr == "label" {
                    openHABWidgetMapping.label = dictionary.valueForKey(keyStr!) as? String
                }
            }
        }
        return openHABWidgetMapping
    }
}