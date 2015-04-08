//
//  OpenHABSitemap.swift
//  GLAD
//
//  Created by Matias Gualino on 28/3/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import Foundation

class OpenHABSitemap {
    var name : String!
    var icon : String!
    var label : String!
    var link : String!
    var leaf : String!
    var homepageLink : String!
    
    class func initWithDictionary(dictionary: NSDictionary) -> OpenHABSitemap {
        var sitemap = OpenHABSitemap()
        for key in dictionary.allKeys {
            let keyStr = (key as? String)
            if keyStr == "homepage" {
                let homepageDic = dictionary.valueForKey(keyStr!) as? NSDictionary
                if homepageDic != nil {
                    for homepageDicKey in homepageDic!.allKeys {
                        let homepageDicKeyStr = (homepageDicKey as? String)
                        if homepageDicKeyStr == "link" {
                            sitemap.homepageLink = homepageDic!.valueForKey(homepageDicKeyStr!) as? String
                        } else if homepageDicKeyStr == "leaf" {
                            sitemap.link = homepageDic!.valueForKey(homepageDicKeyStr!) as? String
                        }
                    }
                }
            } else if keyStr == "name" {
                sitemap.name = dictionary.valueForKey(keyStr!) as? String
            } else if keyStr == "icon" {
                sitemap.icon = dictionary.valueForKey(keyStr!) as? String
            } else if keyStr == "label" {
                sitemap.label = dictionary.valueForKey(keyStr!) as? String
            } else if keyStr == "link" {
                sitemap.link = dictionary.valueForKey(keyStr!) as? String
            }
        }
        return sitemap
    }
    
    class func initWithXML(xmlElement: GDataXMLElement) -> OpenHABSitemap {
        var sitemap = OpenHABSitemap()
        for child in xmlElement.children() {
            let childElement = child as GDataXMLElement
            if childElement.name() == "homepage" {
                for childChildEle in childElement.children() {
                    let childChildElement = childChildEle as GDataXMLElement
                    if childChildElement.name() == "link" {
                        sitemap.homepageLink = childChildElement.stringValue()
                    }
                    if childChildElement.name() == "leaf" {
                        sitemap.leaf = childChildElement.stringValue()
                    }
                }
            } else if childElement.name() == "name" {
                sitemap.name = childElement.stringValue()
            } else if childElement.name() == "icon" {
                sitemap.icon = childElement.stringValue()
            } else if childElement.name() == "label" {
                sitemap.label = childElement.stringValue()
            } else if childElement.name() == "link" {
                sitemap.link = childElement.stringValue()
            }
        }
        return sitemap
    }
}