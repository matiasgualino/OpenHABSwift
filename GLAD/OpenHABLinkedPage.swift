//
//  OpenHABLinkedPage.swift
//  GLAD
//
//  Created by Matias Gualino on 28/3/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import Foundation

class OpenHABLinkedPage {
    
    var pageId : String!
    var title : String!
    var icon : String!
    var link : String!
    
    class func initWithDictionary(dictionary: NSDictionary) -> OpenHABLinkedPage {
        var linkedPage = OpenHABLinkedPage()
        for key in dictionary.allKeys {
            let keyStr = (key as? String)
            if keyStr == "id" {
                linkedPage.pageId = dictionary.valueForKey(keyStr!) as? String
            } else if keyStr == "title" {
                linkedPage.title = dictionary.valueForKey(keyStr!) as? String
            } else if keyStr == "icon" {
                linkedPage.icon = dictionary.valueForKey(keyStr!) as? String
            } else if keyStr == "link" {
                linkedPage.link = dictionary.valueForKey(keyStr!) as? String
            }
        }
        return linkedPage
    }
    
    class func initWithXML(xmlElement: GDataXMLElement) -> OpenHABLinkedPage {
        var linkedPage = OpenHABLinkedPage()
        for child in xmlElement.children() {
            let childElement = child as? GDataXMLElement
            if childElement != nil {
                if childElement!.name() == "id" {
                    linkedPage.pageId = childElement!.stringValue()
                } else if childElement!.name() == "title" {
                    linkedPage.title = childElement!.stringValue()
                } else if childElement!.name() == "icon" {
                    linkedPage.icon = childElement!.stringValue()
                } else if childElement!.name() == "link" {
                    linkedPage.link = childElement!.stringValue()
                }
            }
        }
        return linkedPage
    }
}