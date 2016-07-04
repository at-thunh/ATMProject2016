//
//  History.swift
//  ATMDemo
//
//  Created by AsianTech on 6/30/16.
//  Copyright © 2016 AsianTech. All rights reserved.
//

import Foundation
import RealmS

class History: Object {
    dynamic var id = 0
    dynamic var idAccount = ""
    dynamic var kindTransaction = 0
    dynamic var amountTransaction = "0"
    dynamic var balance = ""
    dynamic var date = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // Incrementa ID
    func IncrementaID() -> Int {
        let realm = try? Realm()
        let RetNext: NSArray = Array(realm!.objects(History).sorted("id"))
        let last = RetNext.lastObject
        if RetNext.count > 0 {
            let valor = last?.valueForKey("id") as? Int
            return valor! + 1
        } else {
            return 0000000001
        }
    }
    
}
