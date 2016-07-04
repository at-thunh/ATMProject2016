//
//  BillView.swift
//  ATMDemo
//
//  Created by AsianTech on 6/30/16.
//  Copyright © 2016 AsianTech. All rights reserved.
//

import UIKit

protocol BillViewDelegate: NSObjectProtocol {
    func backHome()
}

class BillView: UIView {
    @IBOutlet private weak var dateTransactionLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var accountLabel: UILabel!
    @IBOutlet private weak var backView: UIView!
    var billViewDelegate: BillViewDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.showLikePopUp()
    }
    
    func viewData(numberCard: String, amount: String, date: String) {
        self.accountLabel.text = numberCard
        self.amountLabel.text = amount
        self.dateTransactionLabel.text = String(date.characters.prefix(10))
    }
    
    @IBAction func clickHome(sender: AnyObject) {
        billViewDelegate.backHome()
    }
}
