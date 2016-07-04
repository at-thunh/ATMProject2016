//
//  ShowMoneyView.swift
//  ATMDemo
//
//  Created by AsianTech on 7/1/16.
//  Copyright © 2016 AsianTech. All rights reserved.
//

import UIKit
protocol ShowMoneyViewDelegate: NSObjectProtocol {
    func backGetMoneyVC()
}

class ShowMoneyView: UIView {
    @IBOutlet weak var money10Label: UILabel!
    @IBOutlet weak var money20Label: UILabel!
    @IBOutlet weak var money50Label: UILabel!
    @IBOutlet weak var money100Label: UILabel!
    @IBOutlet weak var money200Label: UILabel!
    @IBOutlet weak var money500Label: UILabel!
    var delegate: ShowMoneyViewDelegate!
    
    func ViewData(money10: String, money20: String, money50: String, money100: String, money200: String, money500: String) {
        money10Label.text = "\(money10) tờ 10.000"
        money20Label.text = "\(money20) tờ 20.000"
        money50Label.text = "\(money50) tờ 50.000"
        money100Label.text = "\(money100) tờ 100.000"
        money200Label.text = "\(money200) tờ 200.000"
        money500Label.text = "\(money500) tờ 500.000"
    }
    
    //MARK: Action
    @IBAction func clickBill(sender: AnyObject) {
        delegate.backGetMoneyVC()
    }
}
