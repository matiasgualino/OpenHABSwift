//
//  OpenHABSitemapPage.swift
//  GLAD
//
//  Created by Matias Gualino on 28/3/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import Foundation

protocol OpenHABSitemapPageDelegate {
    func sendCommand(item: OpenHABItem, command: String)
}

class OpenHABSitemapPage : OpenHABSitemapPageDelegate, OpenHABWidgetDelegate {
    var widgets : [OpenHABWidget]!
    var pageId : String!
    var title : String!
    var link : String!
    var leaf : String!
    var delegate : OpenHABSitemapPageDelegate!
    
    func sendCommand(item: OpenHABItem, command: String) {
        println("SitemapPage sending command \(command) to \(item.name)")
        self.delegate.sendCommand(item, command: command)
    }
    
    class func initWithDictionary(dictionary: NSDictionary) -> OpenHABSitemapPage {
       	var sitemapPage = OpenHABSitemapPage()
        sitemapPage.widgets = [OpenHABWidget]()
        sitemapPage.pageId = dictionary.valueForKey("id") as? String
        sitemapPage.title = dictionary.valueForKey("title") as? String
        sitemapPage.link = dictionary.valueForKey("link") as? String
        sitemapPage.leaf = dictionary.valueForKey("leaf") as? String
        
        var widgetsArray = dictionary.valueForKey("widgets") as? [NSDictionary]
        if widgetsArray != nil {
            for widgetDictionary in widgetsArray! {
                var newWidget = OpenHABWidget.initWithDictionary(widgetDictionary)
                newWidget.delegate = sitemapPage
                sitemapPage.widgets.append(newWidget)
            }
        }
        
        return sitemapPage
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