//
//  HistoryCell.swift
//  ATMDemo
//
//  Created by AsianTech on 6/30/16.
//  Copyright © 2016 AsianTech. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {    
    @IBOutlet private weak var transactionLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: Func
    func viewData(history: History) {
        dateLabel.text = String( history.date.characters.prefix(10))
        if history.kindTransaction == 1 {
            transactionLabel.text = "Đã gởi - \(history.amountTransaction)"
        } else {
            transactionLabel.text = "Đã rút - \(history.amountTransaction)"
        }
    }
    
}
