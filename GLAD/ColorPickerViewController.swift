//
//  ColorPickerViewController.swift
//  GLAD
//
//  Created by Matias Gualino on 4/4/15.
//  Copyright (c) 2015 Glad. All rights reserved.
//

import Foundation
import UIKit

class ColorPickerViewController : UIViewController {
    var widget : OpenHABWidget!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
	
	init() {
		super.init(nibName: nil, bundle: nil)
	}
	
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        var colorDidChangeBlock : NKOColorPickerDidChangeColorBlock = {
            (color: UIColor!) in Void()
            var hue : CGFloat = 0.0
            var saturation : CGFloat = 0.0
            var brightness : CGFloat = 0.0
            var alpha : CGFloat = 0.0
            color!.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
            hue = hue*360
            saturation = saturation*100
            brightness = brightness*100
            var command = String(format: "%.2f,%.2f,%.2f", arguments: [hue, saturation, brightness])
            self.widget.sendCommand(command)
        }
        
        var viewFrame : CGRect = self.view.frame
        var pickerFrame : CGRect = CGRectMake(viewFrame.origin.x, viewFrame.origin.y + viewFrame.size.height/20, viewFrame.size.width, viewFrame.size.height - viewFrame.size.height/5)
        var colorPickerView : NKOColorPickerView = NKOColorPickerView(frame: pickerFrame, color: UIColor.blueColor(), andDidChangeColorBlock: colorDidChangeBlock)
        self.view.addSubview(colorPickerView)
        if self.widget != nil {
            colorPickerView.color = self.widget.item.stateAsUIColor()
        }
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}