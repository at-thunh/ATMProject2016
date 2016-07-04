//
//  CheckPassViewController.swift
//  ATMDemo
//
//  Created by AsianTech on 6/29/16.
//  Copyright © 2016 AsianTech. All rights reserved.
//

import UIKit
import RealmS

class CheckPassViewController: UIViewController {
    var isSend = 0
    private var pass = ""
    private var userData: Results<User>?
    private var accountData: Results<Account>?
    @IBOutlet private weak var passTextField: UITextField!
    @IBOutlet private weak var numberAccountTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Function
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: Action
    
    @IBAction func clickHome(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func clickOK(sender: AnyObject) {
        self.view.endEditing(true)
        if passTextField.text == "" || numberAccountTextfield.text == "" {
            let alertView = CBAlertView(title: AppDefine.AppName,
                                        message: AppDefine.messageFillFull,
                                        delegate: self,
                                        cancelButtonTitle: "Ok",
                                        otherButtonTitles: nil)
            alertView.show()
        } else {
            let filter = RealmS().objects(User).filter("numberCard == %@ && pass == %@", numberAccountTextfield.text!, passTextField.text! )
            print(filter.count)
            if filter.count == 0 {
                let alertView = CBAlertView(title: AppDefine.AppName,
                                            message: AppDefine.errorLogin,
                                            delegate: self,
                                            cancelButtonTitle: "Ok",
                                            otherButtonTitles: nil)
                alertView.show()
            } else {
                if isSend == 0 {
                    let getMoneyVC = GetMoneyViewController()
                    getMoneyVC.numberCard = numberAccountTextfield.text!
                    self.navigationController?.pushViewController(getMoneyVC, animated: true)
                } else if isSend == 1 {
                    let sendMoneyVC = SendMoneyViewController()
                    sendMoneyVC.numberCard = numberAccountTextfield.text!
                    self.navigationController?.pushViewController(sendMoneyVC, animated: true)
                } else {
                    let historyVC = HistoryViewController()
                    historyVC.numberCard = numberAccountTextfield.text!
                    self.navigationController?.pushViewController(historyVC, animated: true)
                }
                numberAccountTextfield.text = ""
                passTextField.text = ""
            }
        }
    }
    
}
