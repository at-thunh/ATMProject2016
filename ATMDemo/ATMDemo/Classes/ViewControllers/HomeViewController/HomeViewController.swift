//
//  HomeViewController.swift
//  ATMDemo
//
//  Created by AsianTech on 6/29/16.
//  Copyright © 2016 AsianTech. All rights reserved.
//

import UIKit
import RealmS

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpData()
    }
    
    //MARK: SetupUI
    func setUpUI() {
        navigationController?.navigationBarHidden = true
    }
    
    //MARK: SetupData
    func setUpData() {
        let userDefault = NSUserDefaults.standardUserDefaults()
        if let name = userDefault.valueForKey("runFirst") {
            print("No \(name)")
        } else {
            RealmS().write { realm in
                realm.deleteAll()
            }
            userDefault.setValue("runFirst", forKey: "runFirst")            
        }
    }
    
    func addMoneyAtm() {
        let atm = ATM()
        atm.sheets10 = 5
        atm.sheets20 = 5
        atm.sheets50 = 5
        atm.sheets100 = 5
        atm.sheets200 = 5
        atm.sheets500 = 5
        atm.amount = "4400000"
        RealmS().write { realm in
            realm.add(atm)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Action
    @IBAction func clickGet(sender: AnyObject) {
        let checkPass = CheckPassViewController()
        checkPass.isSend = 0
        self.navigationController?.pushViewController(checkPass, animated: true)
    }
    @IBAction func clickSend(sender: AnyObject) {
        let checkPass = CheckPassViewController()
        checkPass.isSend = 1
        self.navigationController?.pushViewController(checkPass, animated: true)
    }
    
    @IBAction func clickRegister(sender: AnyObject) {
        let registerVC = RegisterViewController()
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    @IBAction func clickHistory(sender: AnyObject) {
        let checkPass = CheckPassViewController()
        checkPass.isSend = 2
        self.navigationController?.pushViewController(checkPass, animated: true)
    }
}
