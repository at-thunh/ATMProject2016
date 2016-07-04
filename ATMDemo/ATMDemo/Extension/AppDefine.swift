//
//  AppDefine.swift
//  ATMDemo
//
//  Created by AsianTech on 6/29/16.
//  Copyright © 2016 AsianTech. All rights reserved.
//

import UIKit

struct AppDefine {
    static let AppName = "ATMDemo"
    static let messagePhone = "Vui lòng nhập lại số điện thoại"
    static let messageCmnd = "Vui lòng nhập lại số CMND"
    static let messageFillFull = "Vui lòng nhập đầy đủ thông tin"
    static let messagePass = "Mật khẩu gồm 4 số"
    static let passDifferent = "Vui lòng nhập lại mật khẩu"
    static let messageThan5Million = "Vui lòng không rút quá 5000000/lần"
    static let errorLogin = "Số tài khoản và mật khẩu không chính xác"
    static let moneyNotEnough = "Vui lòng đến trạm ATM gần nhất để thực hiện giao dịch"
    static let messageOdd = "Không được rút số lẻ dưới 10000"
    static let moneyAccountEnough = "Tiền trong tài khoản bạn không đủ để giao dịch"
}

struct DateFormatter {
    static let ZTDateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    static let Date = "yyyy/MM/dd"
    static let Time = "HH:mm:ss"
    static let DotDate = "yyyy.MM.dd"
}
