//
//  HistoryBill.swift
//  ATMDemo
//
//  Created by AsianTech on 6/30/16.
//  Copyright © 2016 AsianTech. All rights reserved.
//

import UIKit

class HistoryBill: UIView {
    @IBOutlet private weak var idBillLabel: UILabel!
    @IBOutlet private weak var idAccountLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var balanceLabel: UILabel!
    @IBOutlet private weak var amountTransactionLabel: UILabel!
    @IBOutlet private weak var kindTransactionLabel: UILabel!
    
    //MARK: Function
    func viewData(history: History) {
        idBillLabel.text = "\(history.id)"
        idAccountLabel.text = history.idAccount
        dateLabel.text = String( history.date.characters.prefix(10))
        balanceLabel.text = history.balance
        amountTransactionLabel.text = "\(history.amountTransaction)"
        if history.kindTransaction == 0 {
            kindTransactionLabel.text = "Rút tiền"
        } else {
            kindTransactionLabel.text = "Gởi tiền"
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.removeFromSuperview()
    }
    
}
