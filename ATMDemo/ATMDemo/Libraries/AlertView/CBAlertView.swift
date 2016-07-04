//
//  CBAlertView.swift
//  CardBook
//
//  Created by Chi Phuong on 2/25/16.
//  Copyright © 2016 Asian Tech Co.,Ltd. All rights reserved.
//

import Foundation
import UIKit

@objc protocol CBAlerViewDelegate {
    optional func alertView(alertView: CBAlertView, clickedButtonAtIndex: Int)
    optional func alertViewCancel(alertView: CBAlertView)
}

class CBAlertView: UIView {
    // Font
    var titleFont = UIFont.fontHirakakuBold(18)
    var messageFont = UIFont.fontHirakaku(15)
    var buttonFont = UIFont.boldSystemFontOfSize(18)
    var cancelFont = UIFont.boldSystemFontOfSize(18)
    
    // Color
    var contentBackgroundColor = UIColor.whiteColor()
    var markBackgroundColor = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0.4)
    var titleColor = UIColor.mainOrangeColor()
    var messageColor = UIColor(red: 93 / 255, green: 93 / 255, blue: 93 / 255, alpha: 1)
    var lineColor = UIColor.mainOrangeColor()
    var buttonColor = UIColor.mainOrangeColor()
    
    // Size and Position
    private let paddingTopBottom: CGFloat = 20
    private let paddingLeftRight: CGFloat = 15
    private let spaceBetweenTitleMessage: CGFloat = 10
    private let widthAlertView: CGFloat = 270
    private let heightButton: CGFloat = 44
    private let mainFrame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
    private var widthButton: CGFloat = 0
    
    private var indexButtonDissmiss = 0
    private var animationDissmiss = false
    private var buttons: [UIButton] = [UIButton]()
    private var hasCancelButton = false
    private var contentView, messageView, buttonView, markBackgrounView: UIView!
    private var cancelButton: String?
    private var otherButton: [String]?
    var title: String?
    var message: String?
    var numberofButtons: Int {
        return buttons.count
    }
    var delegate: CBAlerViewDelegate?
    // if the delegate does not implement -alertViewCancel:, we pretend this button was clicked on. default is -1
    var cancelButtonIndex: Int = -1
    // -1 if no otherButtonTitles or initWithTitle:... not used
    var firstOtherButtonIndex: Int {
        if hasCancelButton {
            return -1
        } else {
            return 0
        }
    }
    
    // MARK : - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(title: String?,
        message mess: String?,
        delegate: AnyObject?,
        cancelButtonTitle cancel: String?,
        otherButtonTitles button: [String]?) {
        super.init(frame: mainFrame)
        if let delegate = delegate as? CBAlerViewDelegate {
            self.delegate = delegate 
        }
        self.title = title ?? ""
        self.message = mess ?? ""
        self.cancelButton = cancel
        self.otherButton = button
    }
    
    private func createView() {
        let mainFrame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
        contentView = UIView()
        markBackgrounView = UIView(frame: mainFrame)
        
        messageView = setUpContentView(self.title, message: self.message)
        buttonView = setUpOtherButton(self.otherButton, cancelButtonTitle: self.cancelButton)
        messageView.frame = CGRect(x: 0, y: 0, width: messageView.frame.width, height: messageView.frame.height)
        buttonView.frame = CGRect(x: 0, y: messageView.frame.height + 1, width: buttonView.frame.width, height: buttonView.frame.height)
        contentView.frame = CGRect(x: 0, y: 0, width: widthAlertView, height: messageView.frame.height + buttonView.frame.height + 1)
        contentView.backgroundColor = contentBackgroundColor
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        contentView.center = self.center
        contentView.addSubview(messageView)
        contentView.addSubview(buttonView)
        
        markBackgrounView.backgroundColor = markBackgroundColor
        if let _ = self.cancelButton {
            indexButtonDissmiss = 0
        } else {
            indexButtonDissmiss = -1
        }
        
        self.addSubview(markBackgrounView)
        self.addSubview(contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    private func setUpContentView(title: String?, message: String?) -> UIView {
        // Init
        var titleLabel = UILabel()
        var messageLabel = UILabel()
        let contentView = UIView()
        var totalHeight: CGFloat = 0
        
        // Init titleLabel
        titleLabel.frame = CGRect(x: paddingLeftRight, y: paddingTopBottom, width: widthAlertView - 2 * paddingLeftRight, height: 0)
        // Setup property of title
        titleLabel.text = title ?? ""
        titleLabel.font = titleFont
        titleLabel.textColor = titleColor
        titleLabel = lineCountForText(titleLabel)
        
        // Caculator height title
        let heightTitle = titleLabel.frame.height + 20
        titleLabel.frame = CGRect(x: titleLabel.frame.origin.x, y: titleLabel.frame.origin.y, width: titleLabel.frame.width, height: heightTitle)
        // Init message label
        messageLabel.frame = CGRect(x: paddingLeftRight,
            y: spaceBetweenTitleMessage + paddingTopBottom + heightTitle,
            width: widthAlertView - 2 * paddingLeftRight,
            height: 0)
        
        // Setup property message
        messageLabel.text = message ?? ""
        messageLabel.font = messageFont
        messageLabel.textColor = messageColor
        messageLabel = lineCountForText(messageLabel)
        
        let heightMessage = messageLabel.frame.height + 20
        messageLabel.frame = CGRect(x: messageLabel.frame.origin.x,
            y: messageLabel.frame.origin.y,
            width: messageLabel.frame.width,
            height: heightMessage)
        
        totalHeight = messageLabel.frame.origin.y + heightMessage
        
        contentView.frame = CGRect(x: 0, y: 0, width: widthAlertView, height: totalHeight + 20)
        
        if self.title == "" {
            messageLabel.center = contentView.center
        }
        contentView.addSubview(titleLabel)
        contentView.addSubview(messageLabel)
        return contentView
    }
    
    private func setUpOtherButton(otherButtonTitles: [String]?, cancelButtonTitle: String?) -> UIView {
        var buttonString = [String]()
        if let cancel = cancelButtonTitle {
            buttonString.append(cancel)
            hasCancelButton = true
            cancelButtonIndex = 0
        } else {
            self.cancelButtonIndex = 1
        }
        
        if let buttonTitles = otherButtonTitles {
            buttonString.appendContentsOf(buttonTitles)
        }
        
        let buttonView = UIView(frame: CGRect(x: 0, y: 0, width: widthAlertView, height: heightButton))
        let lineTop = UIView(frame: CGRect(x: 0, y: 0, width: widthAlertView, height: 1))
        lineTop.backgroundColor = lineColor
        buttonView.addSubview(lineTop)
        
        // Call method create list button
        createButtonofAlertView(buttonString)
        
        // Add button into buttonView
        var i = 0
        for button in buttons {
            if i == 0 {
                buttonView.addSubview(button)
            } else {
                let middleView = UIView(frame: CGRect(x: button.frame.origin.x, y: 0, width: 1, height: heightButton))
                middleView.backgroundColor = lineColor
                buttonView.addSubview(middleView)
                buttonView.addSubview(button)
            }
            i += 1
        }
        return buttonView
    }
    
    private func lineCountForText(label: UILabel) -> UILabel {
        // Setup Attributed
        let textAttributed = NSMutableAttributedString(attributedString: label.attributedText!)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        style.alignment = NSTextAlignment.Center
        textAttributed.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: textAttributed.length))
        // Height of label
        label.attributedText = textAttributed
        let font = label.font
        let string = label.text! as NSString
        let size = string.boundingRectWithSize(CGSize(width: label.frame.size.width,
                height: CGFloat.infinity),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName: font,
                NSParagraphStyleAttributeName: style],
            context: nil).size
        label.frame = CGRect(x: label.frame.origin.x, y: label.frame.origin.y, width: label.frame.size.width, height: size.height)
        label.numberOfLines = 0
        return label
    }
    
    private func createButtonofAlertView(buttonTitles: [String]) {
        widthButton = widthAlertView / CGFloat(buttonTitles.count)
        for i in 0..<buttonTitles.count {
            let title = buttonTitles[i]
            let button = UIButton(type: .Custom)
            if i == 0 {
                button.titleLabel?.font = cancelFont
            } else {
                button.titleLabel?.font = buttonFont
            }
            button.frame = CGRect(x: widthButton * CGFloat(i), y: 1, width: widthButton, height: heightButton - 1)
            button.setTitle(title, forState: .Normal)
            button.setTitleColor(buttonColor, forState: .Normal)
            button.addTarget(self, action: #selector(CBAlertView.clickButton(_:)), forControlEvents: .TouchUpInside)
            button.tag = i
            buttons.append(button)
        }
    }
    
    // MARK: Actions
    
    func clickButton(button: UIButton) {
        let tag = button.tag
        
        if hasCancelButton && tag == 0 {
//            delegate?.alertViewCancel!(self)
            delegate?.alertViewCancel?(self)
        } else {
            delegate?.alertView!(self, clickedButtonAtIndex: tag)
        }
        if tag == indexButtonDissmiss {
            self.dismissAlertView(animationDissmiss)
        } else {
            self.dismissAlertView(true)
        }
    }
    
    // MARK: Public
    func show() {
        createView()
        let window = UIApplication.sharedApplication().windows[0]
        center = window.center
        window.addSubview(self)
        contentView.layer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
        UIView.animateWithDuration(0.7, delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1.0,
            options: .TransitionNone,
            animations: {
                self.contentView.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
            }, completion: nil)
    }
    
    func dismissAlertView(animated: Bool) {
        if animated {
            contentView.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
            UIView.animateWithDuration(0.7, delay: 0.0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 1.0,
                options: .TransitionNone,
                animations: {
                    self.contentView.layer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
                }, completion: {
                    (finish) in
                    self.removeFromSuperview()
                })
        } else {
            self.removeFromSuperview()
        }
    }
    
    func dismissAlertView(clickButtonIndex index: Int, animation: Bool) {
        if index >= 0 {
            indexButtonDissmiss = index
            animationDissmiss = animation
        }
    }
}
