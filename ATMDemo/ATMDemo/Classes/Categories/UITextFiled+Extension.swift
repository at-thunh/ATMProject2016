//
//  UITextFiled+PlaceHolder.swift
///  CardBook
//
//  Created by Chi Phuong on 12/16/15.
//  Copyright © 2015 Asian Tech Co.,Ltd. All rights reserved.
//

import UIKit

extension UITextField {
    func setPlaceHolder
    (str: String) -> Void {
        let color = UIColor.whiteColor()
        self.attributedPlaceholder = NSAttributedString(string: str, attributes: [NSForegroundColorAttributeName: color])
    }
    
    func checkLimitCharacter(characterLimit: Int, range: NSRange) -> Bool {
        return !(self.text!.characters.count > characterLimit - 1 &&
            text!.characters.count > range.length)
    }
}
