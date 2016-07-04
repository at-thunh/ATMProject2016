//
//  String.swift
//  SwiftUtils
//
//  Created by DaoNV on 10/7/15.
//  Copyright © 2015 Astraler Technology. All rights reserved.
//

import UIKit

extension String {
  public init(aClass: AnyClass) {
    let name = NSStringFromClass(aClass).componentsSeparatedByString(".").last!
    self.init(name)
  }
  
  public subscript (index: Int) -> Character? {
    let range = startIndex.advancedBy(index)
    if range < startIndex || range > endIndex {
      return nil
    }
    return self[range]
  }
  
  public subscript (index: Int) -> String? {
    let range = startIndex.advancedBy(index)
    if let char: Character = self[range] {
      return String(char)
    }
    return nil
  }
  
  public var length: Int {
    return self.characters.count
  }
  
  public var capitalized: String {
    return capitalizedString
  }
  
  // Regex
//  public func matches(pattern: String, ignoreCase: Bool = false) -> [NSTextCheckingResult]? {
//    if let regex = NSRegularExpression.regex(pattern, ignoreCase: ignoreCase) {
//      return regex.matchesInString(self, options: [], range: NSMakeRange(0, length)).map { $0 }
//    }
//    return nil
//  }
//  
//  public func contains(pattern: String, ignoreCase: Bool = false) -> Bool? {
//    if let regex = NSRegularExpression.regex(pattern, ignoreCase: ignoreCase) {
//      let range = NSMakeRange(0, self.characters.count)
//      return regex.firstMatchInString(self, options: [], range: range) != nil
//    }
//    return nil
//  }
//  
//  public func replace(pattern: String, withString replacementString: String, ignoreCase: Bool = false) -> String? {
//    if let regex = NSRegularExpression.regex(pattern, ignoreCase: ignoreCase) {
//      let range = NSMakeRange(0, self.characters.count)
//      return regex.stringByReplacingMatchesInString(self, options: [], range: range, withTemplate: replacementString)
//    }
//    return nil
//  }
  
  
  public func trimmedLeft (characterSet set: NSCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()) -> String {
    if let range = rangeOfCharacterFromSet(set.invertedSet) {
      return self[range.startIndex..<endIndex]
    }
    return ""
  }
  
  public func trimmedRight (characterSet set: NSCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()) -> String {
    if let range = rangeOfCharacterFromSet(set.invertedSet, options: NSStringCompareOptions.BackwardsSearch) {
      return self[startIndex..<range.endIndex]
    }
    return ""
  }
  
  public func trimmed () -> String {
    return trimmedLeft().trimmedRight()
  }
  
//  public static func random(var length len: Int = 0, charset: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") -> String {
//    if len < 1 {
//      len = Int.random(max: 16)
//    }
//    var result = String()
//    let max = charset.length - 1
//    for _ in 0..<len {
//      result += String(charset[Int.random(min: 0, max: max)]!)
//    }
//    return result
//  }
  
  public var intValue: Int {
    return (self as NSString).integerValue
  }
  
  public var doubleValue: Double {
    return (self as NSString).doubleValue
  }
  
  public var floatValue: Float {
    return (self as NSString).floatValue
  }
  
  public var boolValue: Bool {
    return (self as NSString).boolValue
  }
  
  public func appendPathComponent(str: String) -> String {
    let s = (self as NSString).stringByAppendingPathComponent(str)
    if s.hasSuffix("/") {
      return s
    }
    return s + "/"
  }
  
  public var pathComponents: [String] {
    return (self as NSString).pathComponents
  }
  
  public var lastPathComponent: String {
    return (self as NSString).lastPathComponent
  }
  
  public var pathExtension: String {
    return (self as NSString).pathExtension
  }
  
  public var url: NSURL? {
    return NSURL(string: self)!
  }
  
  public var host: String {
    if let url = url, host = url.host {
      return host
    }
    return ""
  }
  
  public var localized: String {
    return NSLocalizedString(self, comment: "")
  }
  
  public func localized(comment: String) -> String {
    return NSLocalizedString(self, comment: comment)
  }
  
  // MARK: Validation
  public enum Regex: String {
    case Number         = "^(?:|0|[1-9]\\d*)(?:\\.\\d*)?$"
    case Name           = "[a-zA-Z\\s]+"
    case Email1         = ".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*"
    case Email2         = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
    case Password       = "[a-zA-Z0-9_]+"
    case URL            = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
  }
  
  public func validate(regex: String) -> Bool {
    let pre = NSPredicate(format: "SELF MATCHES %@", regex)
    return pre.evaluateWithObject(self)
  }
  
  public func validate(regex: Regex) -> Bool {
    return validate(regex.rawValue)
  }
}

// MARK: Character
extension Character {
  public var intValue: Int {
    return (String(self) as NSString).integerValue
  }
}

// MARK: NSMutableAttributedString
extension NSMutableAttributedString {
  public func appendString(string: String, attributes: [String : AnyObject]) {
    let attStr = NSAttributedString(string: string, attributes: attributes)
    appendAttributedString(attStr)
  }
}

// MARK: NSMutableParagraphStyle
extension NSMutableParagraphStyle {
  public static func defaultStyle() -> NSMutableParagraphStyle! {
    let style = NSMutableParagraphStyle()
    let defaultStyle = NSParagraphStyle.defaultParagraphStyle()
    style.lineSpacing = defaultStyle.lineSpacing
    style.paragraphSpacing = defaultStyle.paragraphSpacing
    style.alignment = defaultStyle.alignment
    style.firstLineHeadIndent = defaultStyle.firstLineHeadIndent
    style.headIndent = defaultStyle.headIndent
    style.tailIndent = defaultStyle.tailIndent
    style.lineBreakMode = defaultStyle.lineBreakMode
    style.minimumLineHeight = defaultStyle.minimumLineHeight
    style.maximumLineHeight = defaultStyle.maximumLineHeight
    style.baseWritingDirection = defaultStyle.baseWritingDirection
    style.lineHeightMultiple = defaultStyle.lineHeightMultiple
    style.paragraphSpacingBefore = defaultStyle.paragraphSpacingBefore
    style.hyphenationFactor = defaultStyle.hyphenationFactor
    style.tabStops = defaultStyle.tabStops
    style.defaultTabInterval = defaultStyle.defaultTabInterval
    return style
  }
}
