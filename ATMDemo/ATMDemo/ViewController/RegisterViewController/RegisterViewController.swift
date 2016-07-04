//
//  RegisterViewController.swift
//  ATMDemo
//
//  Created by AsianTech on 6/29/16.
//  Copyright © 2016 AsianTech. All rights reserved.
//

import UIKit
import RealmS

class RegisterViewController: UIViewController {
    
    @IBOutlet private weak var sexSegment: UISegmentedControl!
    @IBOutlet private weak var phoneTextfield: UITextField!
    @IBOutlet private weak var nameTextfield: UITextField!
    @IBOutlet private weak var cmndTextfield: UITextField!
    @IBOutlet private weak var comfirmPassTextfield: UITextField!
    @IBOutlet private weak var passTextfield: UITextField!
    private var userData: Results<User>?
    private var accountData: Results<Account>?
    private var name = ""
    private var phone = ""
    private var sex = 0
    private var cmnd = ""
    private var createDate = ""
    private var pass = ""
    var cardDetailView = CardDetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: SetupUI
    func setUpUI() {
        self.phoneTextfield.delegate = self
        self.cmndTextfield.delegate = self
        self.passTextfield.delegate = self
        self.comfirmPassTextfield.delegate = self
    }
    
    //MARK: Function
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func AddAccount() {
        let account = Account()
        account.id = account.IncrementaID()
        account.amount = "0"
        RealmS().write { (realm) in
            realm.add(account)
        }
        AddUser()
    }
    
    func AddUser() {
        accountData = RealmS().objects(Account)
        let itemAccount = accountData![(accountData?.count)! - 1]
        let user = User()
        user.id = user.IncrementaID()
        user.name = name
        user.sex = sex
        user.phone = phone
        user.idCard = itemAccount
        user.pass = pass
        user.creatDate = createDate
        user.cmnd = cmnd
        user.numberCard = "\(itemAccount.id)"
        RealmS().write { (realm) in
            realm.add(user)
        }
        nameTextfield.text = ""
        phoneTextfield.text = ""
        cmndTextfield.text = ""
        passTextfield.text = ""
        comfirmPassTextfield.text = ""
        
        cardDetailView = (CardDetailView.loadBundle() as? CardDetailView)!
        cardDetailView.viewData(name, numberCard: "\(itemAccount.id)")
        cardDetailView.frame = UIScreen.mainScreen().bounds
        self.navigationController?.view.addSubview(cardDetailView)
    }
    
    //MARK: Action
    @IBAction func clickSelectSex(sender: AnyObject) {
        self.view.endEditing(true)
        switch sexSegment.selectedSegmentIndex {
        case 0:
            sex = 0
        case 1:
            sex = 1
        default:
            break
        }
    }
    
    @IBAction func clickBackHome(sender: AnyObject) {
        self.view.endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func clickRegister(sender: AnyObject) {
        self.view.endEditing(true)
        if nameTextfield.text == "" || phoneTextfield.text == "" || cmndTextfield.text == "" {
            let alertView = CBAlertView(title: AppDefine.AppName,
                                        message: AppDefine.messageFillFull,
                                        delegate: self,
                                        cancelButtonTitle: "Ok",
                                        otherButtonTitles: nil)
            alertView.show()
        } else {
            if phoneTextfield.text?.length < 11 && phoneTextfield.text?.length > 0 {
                let alertView = CBAlertView(title: AppDefine.AppName,
                                            message: AppDefine.messagePhone,
                                            delegate: self,
                                            cancelButtonTitle: "Ok",
                                            otherButtonTitles: nil)
                alertView.show()
            } else if cmndTextfield.text?.length < 9 && cmndTextfield.text?.length > 0 {
                let alertView = CBAlertView(title: AppDefine.AppName,
                                            message: AppDefine.messageCmnd,
                                            delegate: self,
                                            cancelButtonTitle: "Ok",
                                            otherButtonTitles: nil)
                alertView.show()
            } else if passTextfield.text?.length < 4 && passTextfield.text?.length > 0 {
                let alertView = CBAlertView(title: AppDefine.AppName,
                                            message: AppDefine.messagePass,
                                            delegate: self,
                                            cancelButtonTitle: "Ok",
                                            otherButtonTitles: nil)
                alertView.show()
            } else if comfirmPassTextfield.text?.length < 4 && comfirmPassTextfield.text?.length > 0 {
                let alertView = CBAlertView(title: AppDefine.AppName,
                                            message: AppDefine.messagePass,
                                            delegate: self,
                                            cancelButtonTitle: "Ok",
                                            otherButtonTitles: nil)
                alertView.show()
            } else {
                if passTextfield.text != comfirmPassTextfield.text {
                    let alertView = CBAlertView(title: AppDefine.AppName,
                                                message: AppDefine.messagePass,
                                                delegate: self,
                                                cancelButtonTitle: "Ok",
                                                otherButtonTitles: nil)
                    alertView.show()
                } else {
                    name = nameTextfield.text!
                    phone = phoneTextfield.text!
                    cmnd = cmndTextfield.text!
                    pass = passTextfield.text!
                    let dateNow = NSDate()
                    createDate = "\(dateNow)"
                    AddAccount()
                }
            }
        }
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let tagTextField = textField.tag
        if tagTextField == 1 {
            return phoneTextfield.checkLimitCharacter(11, range: range)
        } else if tagTextField == 2 {
            return cmndTextfield.checkLimitCharacter(9, range: range)
        } else if tagTextField == 3 {
            return passTextfield.checkLimitCharacter(4, range: range)
        } else if tagTextField == 4 {
            return comfirmPassTextfield.checkLimitCharacter(4, range: range)
        } else {
            return true
        }
    }
}
