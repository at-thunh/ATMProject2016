//
//  UIColorExtension.swift
//  CardBook
//
//  Created by Chi Phuong on 12/16/15.
//  Copyright © 2015 Asian Tech Co.,Ltd. All rights reserved.
//

import UIKit

/**
 * Custom category of UIColor to load the custom colors according to the selected themes.
 */

extension UIColor {
    
    class func rgbColor(redColor red: Float, greenColor green: Float, blueColor blue: Float) -> UIColor {
        return UIColor(red: CGFloat(red / 255.0), green: CGFloat(green / 255.0), blue: CGFloat(blue / 255.0), alpha: 1.0)
    }
    
    class func rgbaColor(redColor red: Float, greenColor green: Float, blueColor blue: Float, alphaNumber alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(red / 255.0), green: CGFloat(green / 255.0), blue: CGFloat(blue / 255.0), alpha: alpha)
    }
    
    class func mainColor() -> UIColor {
        return UIColor.rgbColor(redColor: 218.0, greenColor: 80.0, blueColor: 10.0)
    }
    
    class func borderColor() -> UIColor {
        return UIColor.rgbColor(redColor: 234, greenColor: 234, blueColor: 234)
    }
    
    class func borderDottedColor() -> UIColor {
        return UIColor.rgbColor(redColor: 173, greenColor: 173, blueColor: 173)
    }
    
    class func mainOrangeColor() -> UIColor {
        return UIColor.rgbColor(redColor: 255, greenColor: 121, blueColor: 31)
    }
    
    class func borderSexViewColor() -> UIColor {
        return UIColor.rgbColor(redColor: 203, greenColor: 203, blueColor: 203)
    }
    
    class func textSexColor() -> UIColor {
        return UIColor.rgbColor(redColor: 116, greenColor: 116, blueColor: 116)
    }
    
    class func backgroundView() -> UIColor {
        return UIColor.rgbColor(redColor: 243, greenColor: 243, blueColor: 243)
    }
    
    class func backgroundNotEnableButton() -> UIColor {
        return UIColor.rgbColor(redColor: 249, greenColor: 249, blueColor: 249)
    }
    
    class func textSearchColor() -> UIColor {
        return UIColor.rgbColor(redColor: 102, greenColor: 102, blueColor: 102)
    }
    
    class func textDetailCoupon() -> UIColor {
        return UIColor.rgbColor(redColor: 93, greenColor: 93, blueColor: 93)
    }
    
    class func textGrayColor() -> UIColor {
        return UIColor.rgbColor(redColor: 77, greenColor: 77, blueColor: 77)
    }
    
    class func backgrounHeaderTableView() -> UIColor {
        return UIColor.makeColorWithHexString("e5e5e5")
    }
    
    class func makeColorWithHexString(hex: String) -> UIColor {
        var cString: String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if cString.hasPrefix("#") {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if cString.characters.count != 6 {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    class func makeColorToolbar() -> UIColor {
        return makeColorWithHexString("1d76d3")
    }
}
