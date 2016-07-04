//
//  CardDetailView.swift
//  ATMDemo
//
//  Created by AsianTech on 6/29/16.
//  Copyright © 2016 AsianTech. All rights reserved.
//

import UIKit

class CardDetailView: UIView {
    @IBOutlet private weak var nameCardLabel: UILabel!
    @IBOutlet private weak var numberCardLabel: UILabel!
    @IBOutlet private weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.showLikePopUp()
    }
    
    func viewData(name: String, numberCard: String) {
        self.nameCardLabel.text = name
        self.numberCardLabel.text = numberCard
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.removeFromSuperview()
    }
    
}
