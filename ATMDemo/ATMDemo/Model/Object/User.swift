//
//  User.swift
//  ATMDemo
//
//  Created by AsianTech on 6/29/16.
//  Copyright © 2016 AsianTech. All rights reserved.
//

import Foundation
import RealmS

class User: Object {
    dynamic var  id: Int = 0
    dynamic var  name = ""
    dynamic var  sex = 0
    dynamic var  phone = ""
    dynamic var  idCard: Account?
    dynamic var  numberCard = ""
    dynamic var  pass = ""
    dynamic var  creatDate = ""
    dynamic var  cmnd = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // Incrementa ID
    func IncrementaID() -> Int {
        let realm = try? Realm()
        let RetNext: NSArray = Array(realm!.objects(User).sorted("id"))
        let last = RetNext.lastObject
        if RetNext.count > 0 {
            let valor = last?.valueForKey("id") as? Int
            return valor! + 1
        } else {
            return 1
        }
    }
}
