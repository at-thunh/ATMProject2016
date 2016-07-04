//
//  UIFontExtension.swift
//  CardBook
//
//  Created by Chi Phuong on 12/16/15.
//  Copyright © 2015 Asian Tech Co.,Ltd. All rights reserved.
//

import UIKit

/**
 * Custom category of UIFont to load the custom fonts according to texts.
 */

extension UIFont {

    class func fontMiso(size: CGFloat) -> UIFont! {
        return UIFont(name: "Miso", size: size)!
    }
    
    class func fontMisoBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Miso-Bold", size: size)!
    }
    class func fontHirakakuBold(size: CGFloat) -> UIFont {
        return UIFont(name: "HiraKakuProN-W6", size: size)!
    }
    class func fontHirakaku(size: CGFloat) -> UIFont {
        return UIFont(name: "HiraKakuProN-W3", size: size)!
    }
}
