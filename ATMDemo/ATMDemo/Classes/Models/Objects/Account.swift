//
//  Account.swift
//  ATMDemo
//
//  Created by AsianTech on 6/29/16.
//  Copyright © 2016 AsianTech. All rights reserved.
//

import Foundation
import RealmS

class Account: Object {
    dynamic var id = 0
    dynamic var amount = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // Incrementa ID
    func IncrementaID() -> Int {
        let realm = try? Realm()
        let RetNext: NSArray = Array(realm!.objects(Account).sorted("id"))
        let last = RetNext.lastObject
        if RetNext.count > 0 {
            let valor = last?.valueForKey("id") as? Int
            return valor! + 1
        } else {
            return 1809000001
        }
    }
}
