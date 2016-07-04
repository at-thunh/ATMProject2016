//
//  SendMoneyViewController.swift
//  ATMDemo
//
//  Created by AsianTech on 6/29/16.
//  Copyright © 2016 AsianTech. All rights reserved.
//

import UIKit
import RealmS

class SendMoneyViewController: UIViewController {
    
    @IBOutlet weak var sheets10TextField: UITextField!
    @IBOutlet weak var sheets20TextField: UITextField!
    @IBOutlet weak var sheets50TextField: UITextField!
    @IBOutlet weak var sheets100TextField: UITextField!
    @IBOutlet weak var sheets200TextField: UITextField!
    @IBOutlet weak var sheets500TextField: UITextField!
    private var atmData: Results<ATM>?
    private var accountData: Results<Account>?
    var numberCard = ""
    private var sheets10 = 0
    private var sheets20 = 0
    private var sheets50 = 0
    private var sheets100 = 0
    private var sheets200 = 0
    private var sheets500 = 0
    private var amount = ""
    private var amountAtm = ""
    private var amountAccount = ""
    private var amountTransaction = 0
    var billView = BillView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: SetUp Data
    func setUpData() {
        atmData = RealmS().objects(ATM)
        amount = atmData![0].amount
        amountAtm = atmData![0].amount
        let filterAccount = RealmS().objects(Account).filter("id == %d", Int(numberCard)!).first
        amountAccount = (filterAccount?.amount)!
    }
    
    //MARK: Function
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func addMoneyAtm() {
        let filterAtm = RealmS().objects(ATM).filter("amount == %@", amountAtm).first
        RealmS().write { (realm) in
            filterAtm?.sheets10 = (filterAtm?.sheets10)! + sheets10
            filterAtm?.sheets20 = (filterAtm?.sheets20)! + sheets20
            filterAtm?.sheets50 = (filterAtm?.sheets50)! + sheets50
            filterAtm?.sheets100 = (filterAtm?.sheets100)! + sheets100
            filterAtm?.sheets200 = (filterAtm?.sheets200)! + sheets200
            filterAtm?.sheets500 = (filterAtm?.sheets500)! + sheets500
            filterAtm?.amount = amount
        }
        addHistory()
        addMoneyAccount()
    }
    
    func addHistory() {
        let history = History()
        history.id = history.IncrementaID()
        history.idAccount = numberCard
        history.kindTransaction = 1
        history.amountTransaction = "\(amountTransaction)"
        history .balance = amountAccount
        let dateNow = NSDate()
        history.date = "\(dateNow)"
        RealmS().write { (realm) in
            realm.add(history)
        }
    }
    
    func addMoneyAccount() {
        let filterAccount = RealmS().objects(Account).filter("id == %d", Int(numberCard)!).first
        RealmS().write { (realm) in
            filterAccount!.amount = amountAccount
        }
        self.sheets10TextField.text = ""
        self.sheets20TextField.text = ""
        self.sheets50TextField.text = ""
        self.sheets100TextField.text = ""
        self.sheets200TextField.text = ""
        self.sheets500TextField.text = ""
        
        billView = (BillView.loadBundle() as? BillView)!
        let dateNow = NSDate()
        billView.viewData(numberCard, amount: amountAccount, date: "\(dateNow)")
        billView.billViewDelegate = self
        billView.frame = UIScreen.mainScreen().bounds
        self.navigationController?.view.addSubview(billView)
        
    }
    
    //MARK: Action
    @IBAction func clickBackHome(sender: AnyObject) {
        let home = HomeViewController()
        self.navigationController?.pushViewController(home, animated: true)
    }
    
    @IBAction func clickSend(sender: AnyObject) {
        self.view.endEditing(true)
        if sheets10TextField.text == "" {
            sheets10 = 0
        } else {
            sheets10 = Int(sheets10TextField.text!)!
            amount = "\(Int(amount)! + Int(sheets10TextField.text!)! * 10000)"
            amountAccount = "\(Int(amountAccount)! + Int(sheets10TextField.text!)! * 10000 )"
            amountTransaction =  amountTransaction + Int(sheets10TextField.text!)! * 10000
        }
        
        if sheets20TextField.text == "" {
            sheets20 = 0
        } else {
            sheets20 = Int(sheets20TextField.text!)!
            amount = "\(Int(amount)! + Int(sheets20TextField.text!)! * 20000)"
            amountAccount = "\(Int(amountAccount)! + Int(sheets20TextField.text!)! * 20000 )"
            amountTransaction = amountTransaction +  Int(sheets20TextField.text!)! * 20000
        }
        
        if sheets50TextField.text == "" {
            sheets50 = 0
        } else {
            sheets50 = Int(sheets50TextField.text!)!
            amount = "\(Int(amount)! + Int(sheets50TextField.text!)! * 50000)"
            amountAccount = "\(Int(amountAccount)! + Int(sheets50TextField.text!)! * 50000 )"
            amountTransaction = amountTransaction +  Int(sheets50TextField.text!)! * 50000
        }
        
        if sheets100TextField.text == "" {
            sheets100 = 0
        } else {
            sheets100 = Int(sheets100TextField.text!)!
            amount = "\(Int(amount)! + Int(sheets100TextField.text!)! * 100000)"
            amountAccount = "\(Int(amountAccount)! + Int(sheets100TextField.text!)! * 100000 )"
            amountTransaction = amountTransaction +  Int(sheets100TextField.text!)! * 100000
        }
        
        if sheets200TextField.text == "" {
            sheets200 = 0
        } else {
            sheets200 = Int(sheets200TextField.text!)!
            amount = "\(Int(amount)! + Int(sheets200TextField.text!)! * 200000)"
            amountAccount = "\(Int(amountAccount)! + Int(sheets200TextField.text!)! * 200000 )"
            amountTransaction = amountTransaction +  Int(sheets200TextField.text!)! * 200000
        }
        
        if sheets500TextField.text == "" {
            sheets500 = 0
        } else {
            sheets500 = Int(sheets500TextField.text!)!
            amount = "\(Int(amount)! + Int(sheets500TextField.text!)! * 500000)"
            amountAccount = "\(Int(amountAccount)! + Int(sheets500TextField.text!)! * 500000 )"
            amountTransaction = amountTransaction + Int(sheets500TextField.text!)! * 500000
        }
        addMoneyAtm()
    }
}

//MARK: BillViewDelegate
extension SendMoneyViewController: BillViewDelegate {
    func backHome() {
        billView.removeFromSuperview()
        let home = HomeViewController()
        self.navigationController?.pushViewController(home, animated: true)
    }
}
