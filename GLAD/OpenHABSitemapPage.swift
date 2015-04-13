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
    
    class func initWithXML(xmlElement: GDataXMLElement) -> OpenHABSitemapPage {
        var sitemapPage = OpenHABSitemapPage()
        sitemapPage.widgets = [OpenHABWidget]()
        for ch in xmlElement.children() {
            var child = ch as? GDataXMLElement
            if child!.name() != "widget" {
                if child!.name() == "id" {
                    sitemapPage.pageId = child!.stringValue()
                } else if child!.name() == "title" {
                    sitemapPage.title = child!.stringValue()
                } else if child!.name() == "link" {
                    sitemapPage.link = child!.stringValue()
                } else if child!.name() == "leaf" {
                    sitemapPage.leaf = child!.stringValue()
                }
            } else {
                var newWidget : OpenHABWidget = OpenHABWidget.initWithXML(child!)
                newWidget.delegate = sitemapPage
                sitemapPage.widgets.append(newWidget)
                var widgetsArr : [GDataXMLElement]? = child!.elementsForName("widget") as? [GDataXMLElement]
                if widgetsArr != nil {
                    if widgetsArr!.count > 0 {
                        for cc in child!.elementsForName("widget")! {
                            var childchild = cc as? GDataXMLElement
                            if child?.name() == "widget" {
                                var newChildWidget : OpenHABWidget = OpenHABWidget.initWithXML(childchild!)
                                newChildWidget.delegate = sitemapPage
                                sitemapPage.widgets.append(newChildWidget)
                            }
                        }
                    }
                }
            }
        }
        return sitemapPage
    }
    
}