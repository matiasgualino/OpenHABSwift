//
//  UIColor+Extensions.swift
//  GLAD
//
//  Created by Matias Gualino on 3/4/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {        
        class func iOS7TableViewBackgroundColor() -> UIColor {
            return colorWithHexString("#EBEBF0")
        }
        
        class func colorWithHexString(hexString: String) -> UIColor {
            let colorString = (hexString as NSString).stringByReplacingOccurrencesOfString("#", withString: "").uppercaseString
            var alpha : CGFloat = 0.0
            var red : CGFloat = 0.0
            var blue : CGFloat = 0.0
            var green : CGFloat = 0.0
            
            switch count(colorString) {
            case 3: // #RGB
                alpha = 1.0
                red = colorComponentFrom(colorString, start: 0, length: 1)
                green = colorComponentFrom(colorString, start: 1, length: 1)
                blue = colorComponentFrom(colorString, start: 2, length: 1)
            case 4: // #ARGB
                alpha = colorComponentFrom(colorString, start: 0, length: 1)
                red = colorComponentFrom(colorString, start: 1, length: 1)
                green = colorComponentFrom(colorString, start: 2, length: 1)
                blue = colorComponentFrom(colorString, start: 3, length: 1)
            case 6: // #RRGGBB
                alpha = 1.0
                red = colorComponentFrom(colorString, start: 0, length: 2)
                green = colorComponentFrom(colorString, start: 2, length: 2)
                blue = colorComponentFrom(colorString, start: 4, length: 2)
            case 8: // #AARRGGBB
                alpha = colorComponentFrom(colorString, start: 0, length: 2)
                red = colorComponentFrom(colorString, start: 2, length: 2)
                green = colorComponentFrom(colorString, start: 4, length: 2)
                blue = colorComponentFrom(colorString, start: 6, length: 2)
            default:
                NSException(name: "Invalid color value", reason: "Color value \(hexString) is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", userInfo: nil)
            }
            
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
        
        class func colorComponentFrom(string: String, start: Int, length: Int) -> CGFloat {
            let substring = (string as NSString).substringWithRange(NSMakeRange(start, length))
            let fullHex = length == 2 ? substring : String(format: "%@%@", arguments: [substring, substring])
            var hexComponent : CUnsignedInt = 0
            NSScanner(string: fullHex).scanHexInt(&hexComponent)
            return CGFloat(hexComponent) / 255.0
        }
}