//
//  OpenHABWidget.swift
//  GLAD
//
//  Created by Matias Gualino on 28/3/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import Foundation

protocol OpenHABWidgetDelegate {
    func sendCommand(item: OpenHABItem, command: String)
}

class OpenHABWidget : NSObject {
    var widgetId: String!
    var label: String!
    var icon: String!
    var type: String!
    var url: String!
    var period: String!
    var minValue: String!
    var maxValue: String!
    var step: String!
    var refresh: String!
    var height: String!
    var isLeaf: String!
    var iconColor: String!
    var labelcolor: String!
    var valuecolor: String!
    var service: String!
    var item : OpenHABItem!
    var linkedPage : OpenHABLinkedPage!
    var text: String!
    var mappings : [OpenHABWidgetMapping]!
    var image : UIImage!
    var delegate : OpenHABWidgetDelegate!
 
    class func initWithXML(xmlElement: GDataXMLElement) -> OpenHABWidget {
        var widget = OpenHABWidget()
        widget.mappings = [OpenHABWidgetMapping]()
        
        for child in xmlElement.children() {
            let childElement = child as? GDataXMLElement
            if childElement != nil {
                if childElement!.name() != "widget" {
                    if childElement!.name() == "item" {
                        widget.item = OpenHABItem.initWithXML(childElement!)
                    } else if childElement!.name() == "mapping" {
                        var mapping = OpenHABWidgetMapping.initWithXML(childElement!)
                        widget.mappings.append(mapping)
                    } else if childElement!.name() == "linkedPage" {
                        widget.linkedPage = OpenHABLinkedPage.initWithXML(childElement!)
                    } else if childElement!.name() == "type" {
                        widget.type = childElement?.stringValue()
                    } else if childElement!.name() == "icon" {
                        widget.icon = childElement?.stringValue()
                    } else if childElement!.name() == "url" {
                        widget.url = childElement?.stringValue()
                    } else if childElement!.name() == "label" {
                        widget.label = childElement?.stringValue()
                    } else if childElement!.name() == "text" {
                        widget.text = childElement?.stringValue()
                    } else if childElement!.name() == "step" {
                        widget.step = childElement?.stringValue()
                    } else {
                        // TODO : LOAD MORE VARIABLES
                    }
                }
            }
        }
        return widget
    }
    
    class func initWithDictionary(dictionary: NSDictionary) -> OpenHABWidget {
        var widget = OpenHABWidget()
        widget.mappings = [OpenHABWidgetMapping]()
        for key in dictionary.allKeys {
            let keyStr = (key as? String)
            if keyStr == "item" {
                widget.item = OpenHABItem.initWithDictionary(dictionary.valueForKey(keyStr!) as NSDictionary)
            } else if keyStr == "mappings" {
                var widgetMappingsArray = dictionary.valueForKey(keyStr!) as? NSArray
                if widgetMappingsArray != nil {
                    for dic in widgetMappingsArray! {
                        var mapping = OpenHABWidgetMapping.initWithDictionary(dic as NSDictionary)
                        widget.mappings.append(mapping)
                    }
                }
            } else if keyStr == "linkedPage" {
                widget.linkedPage = OpenHABLinkedPage.initWithDictionary(dictionary.valueForKey(keyStr!) as NSDictionary)
            } else {
                // TODO : LOAD MORE VARIABLES
            }
        }
        return widget
    }
    
    func labelText() -> String {
        var array = (self.label as String).componentsSeparatedByString("[")
        var valueString = (array[0] as NSString)
        while valueString.hasSuffix(" ") {
            valueString = valueString.substringToIndex(valueString.length - 1)
        }
        return valueString
    }
    
    func labelValue() -> String? {
        var array = (self.label as String).componentsSeparatedByString("[")
        if array.count > 1 {
           var valueString = (array[1] as NSString)
            while valueString.hasSuffix("]") || valueString.hasSuffix(" ") {
                valueString = valueString.substringToIndex(valueString.length - 1)
            }
            return valueString
        } else {
            return nil
        }
    }
    
    func mappingIndexByCommand(command: String) -> Int {
        if self.mappings != nil {
            var i = 0
            for mapping in self.mappings {
                if mapping.command == command {
                    return i
                }
                i++
            }
        }
        return -1
    }
    
    func sendCommand(command: String) {
        if self.delegate != nil && self.item != nil {
            self.delegate.sendCommand(item, command: command)
        }
        if self.item == nil {
            println("Item = nil")
        }
        if self.delegate == nil {
            println("Delegate = nil")
        }
    }
    
}