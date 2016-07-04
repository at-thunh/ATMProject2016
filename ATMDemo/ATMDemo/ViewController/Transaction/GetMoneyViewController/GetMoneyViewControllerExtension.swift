//
//  GetMoneyViewControllerExtension.swift
//  ATMDemo
//
//  Created by AsianTech on 7/1/16.
//  Copyright © 2016 AsianTech. All rights reserved.
//

import Foundation
import UIKit

extension GetMoneyViewController: BillViewDelegate {
    func backHome() {
        let home = HomeViewController()
        billView.removeFromSuperview()
        self.navigationController?.pushViewController(home, animated: true)
    }
}

extension GetMoneyViewController: ShowMoneyViewDelegate {
    func backGetMoneyVC() {
        showMoneyView.removeFromSuperview()
        
        billView = (BillView.loadBundle() as? BillView)!
        let dateNow = NSDate()
        billView.viewData(numberCard, amount: amountAccount, date: "\(dateNow)")
        billView.billViewDelegate = self
        billView.frame = UIScreen.mainScreen().bounds
        self.navigationController?.view.addSubview(billView)
    }
}
