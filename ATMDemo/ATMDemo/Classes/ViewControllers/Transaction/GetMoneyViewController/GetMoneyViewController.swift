//
//  GetMoneyViewController.swift
//  ATMDemo
//
//  Created by AsianTech on 6/29/16.
//  Copyright © 2016 AsianTech. All rights reserved.
//
import UIKit
import RealmS

class GetMoneyViewController: UIViewController {
    
    @IBOutlet private weak var moneyTextfield: UITextField!
    
    private var atmData: Results<ATM>?
    private var accountData: Results<Account>?
    private var amountATM = ""
    var amountAccount = ""
    private var sheets10Atm = 0
    private var sheets20Atm = 0
    private var sheets50Atm = 0
    private var sheets100Atm = 0
    private var sheets200Atm = 0
    private var sheets500Atm = 0
    private var sheet500 = 0
    private var sheet200 = 0
    private var sheet100 = 0
    private var sheet50 = 0
    private var sheet20 = 0
    private var sheet10 = 0
    private var amountFillIn = 0
    private var amountTransaction = ""
    var showMoneyView = ShowMoneyView()
    var billView = BillView()
    var numberCard = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpdata()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK: Setup Data
    func setUpdata() {
        atmData = RealmS().objects(ATM)
        sheets10Atm = atmData![0].sheets10
        sheets20Atm = atmData![0].sheets20
        sheets50Atm = atmData![0].sheets50
        sheets100Atm = atmData![0].sheets100
        sheets200Atm = atmData![0].sheets200
        sheets500Atm = atmData![0].sheets500
        print(sheets10Atm);print("-");print(sheets20Atm);print("-");print(sheets50Atm);print("-")
        print(sheets100Atm);print("-");print(sheets200Atm);print("-");print(sheets500Atm);print("-")
        
        let filterAccount = RealmS().objects(Account).filter("id == %d", Int(numberCard)!).first
        amountAccount = (filterAccount?.amount)!
    }
    
    //MARK: Function
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func getMoneyATM() {
        let filterAtm = RealmS().objects(ATM).filter("sheets10 == %d", sheets10Atm).first
        RealmS().write { (realm) in
            filterAtm?.sheets10 = sheets10Atm - sheet10
            filterAtm?.sheets20 = sheets20Atm - sheet20
            filterAtm?.sheets50 = sheets50Atm - sheet50
            filterAtm?.sheets100 = sheets100Atm - sheet100
            filterAtm?.sheets200 = sheets200Atm - sheet200
            filterAtm?.sheets500 = sheets500Atm - sheet500
            let amountStep1 = (sheets10Atm - sheet10)*10000 + (sheets20Atm - sheet20)*20000 + (sheets50Atm - sheet50)*50000
            let amountStep2 = (sheets100Atm - sheet100)*100000 + (sheets200Atm - sheet200)*200000 + (sheets500Atm - sheet500)*500000
            filterAtm?.amount = "\(amountStep1 + amountStep2)"
        }
    }
    
    func addHistory() {
        let history = History()
        history.id = history.IncrementaID()
        history.idAccount = numberCard
        history.kindTransaction = 0
        history.amountTransaction = "\(amountTransaction)"
        history .balance = amountAccount
        let dateNow = NSDate()
        history.date = "\(dateNow)"
        RealmS().write { (realm) in
            realm.add(history)
        }
    }
    
    func getMoneyAccount() {
        let filterAccount = RealmS().objects(Account).filter("id == %d", Int(numberCard)!).first
        RealmS().write { (realm) in
            filterAccount!.amount = amountAccount
        }
        
        self.moneyTextfield.text = ""
        showMoneyView = (ShowMoneyView.loadBundle() as? ShowMoneyView)!
        showMoneyView.ViewData(String(sheet10), money20: String(sheet20), money50: String(sheet50),
                               money100: String(sheet100), money200: String(sheet200), money500: String(sheet500))
        showMoneyView.delegate = self
        showMoneyView.frame = UIScreen.mainScreen().bounds
        self.navigationController?.view.addSubview(showMoneyView)
    }
    
    //MARK: Action
    
    @IBAction func clickBackHome(sender: AnyObject) {
        let home = HomeViewController()
        self.navigationController?.pushViewController(home, animated: true)
    }
    
    @IBAction func clickOK(sender: AnyObject) {
        self.view.endEditing(true)
        if moneyTextfield.text == "" {
            let alertView = CBAlertView(title: AppDefine.AppName,
                                        message: AppDefine.messageFillFull,
                                        delegate: self,
                                        cancelButtonTitle: "Ok",
                                        otherButtonTitles: nil)
            alertView.show()
        } else if Int(moneyTextfield.text!) >= 5000000 {
            let alertView = CBAlertView(title: AppDefine.AppName,
                                        message: AppDefine.messageThan5Million,
                                        delegate: self,
                                        cancelButtonTitle: "Ok",
                                        otherButtonTitles: nil)
            alertView.show()
        } else if Int(atmData![0].amount) < Int(moneyTextfield.text!)! {
            let alertView = CBAlertView(title: AppDefine.AppName,
                                        message: AppDefine.moneyNotEnough,
                                        delegate: self,
                                        cancelButtonTitle: "Ok",
                                        otherButtonTitles: nil)
            alertView.show()
        } else if (Int(String((moneyTextfield.text)!.characters.suffix(4))) >= 1) &&
            (Int(String((moneyTextfield.text)!.characters.suffix(4))) < 9999) {
            let alertView = CBAlertView(title: AppDefine.AppName,
                                        message: AppDefine.messageOdd,
                                        delegate: self,
                                        cancelButtonTitle: "Ok",
                                        otherButtonTitles: nil)
            alertView.show()
        } else if Int(moneyTextfield.text!) < 10000 {
            let alertView = CBAlertView(title: AppDefine.AppName,
                                        message: AppDefine.messageOdd,
                                        delegate: self,
                                        cancelButtonTitle: "Ok",
                                        otherButtonTitles: nil)
            alertView.show()
        } else if Int(amountAccount) < Int(moneyTextfield.text!)! {
            let alertView = CBAlertView(title: AppDefine.AppName,
                                        message: AppDefine.moneyAccountEnough,
                                        delegate: self,
                                        cancelButtonTitle: "Ok",
                                        otherButtonTitles: nil)
            alertView.show()
        } else {
            amountFillIn = Int(moneyTextfield.text!)!
            if amountFillIn/500000 >= 0 && amountFillIn%500000 > 0 {
                sheet500 = amountFillIn/500000
                if sheet500 >= sheets500Atm {
                    sheet500 = sheets500Atm
                    if sheet500 - sheets500Atm > 0 {
                        amountFillIn = (sheet500 - sheets500Atm) * 500000
                    }
                    
                    if amountFillIn/200000 >= 0 && amountFillIn%200000 > 0 {
                        sheet200 = amountFillIn/200000
                        if sheet200 >= sheets200Atm {
                            sheet200 = sheets200Atm
                            if sheet200 - sheets200Atm > 0 {
                                amountFillIn = (sheet200 - sheets200Atm) * 200000
                            }
                            if amountFillIn/100000 >= 0 && amountFillIn%100000 > 0 {
                                sheet100 = amountFillIn/100000
                                if sheet100 >= sheets100Atm {
                                    sheet100 = sheets100Atm
                                    if sheet100 - sheets100Atm > 0 {
                                        amountFillIn = (sheet100 - sheets100Atm) * 100000
                                    }
                                    if amountFillIn/50000 >= 0 && amountFillIn%50000 > 0 {
                                        sheet50 = amountFillIn/50000
                                        if sheet50 >= sheets50Atm {
                                            sheet50 = sheets50Atm
                                            if sheet50 - sheets50Atm > 0 {
                                                amountFillIn = (sheet50 - sheets50Atm) * 50000
                                            }
                                            if amountFillIn/20000 >= 0 && amountFillIn%20000 > 0 {
                                                sheet20 = amountFillIn/20000
                                                if sheet20 >= sheets20Atm {
                                                    sheet20 = sheets20Atm
                                                    if sheet20 - sheets20Atm > 0 {
                                                        amountFillIn = (sheet20 - sheets20Atm) * 20000
                                                    }
                                                    if amountFillIn/10000 >= 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = sheets10Atm
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                } else {
                                                    amountFillIn = amountFillIn%20000
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                }
                                            } else {
                                                sheet20 = amountFillIn/20000
                                            }
                                        } else {
                                            amountFillIn = amountFillIn%50000
                                            if amountFillIn/20000 >= 0 && amountFillIn%20000 > 0 {
                                                sheet20 = amountFillIn/20000
                                                if sheet20 >= sheets20Atm {
                                                    sheet20 = sheets20Atm
                                                    if sheet20 - sheets20Atm > 0 {
                                                        amountFillIn = (sheet20 - sheets20Atm) * 20000
                                                    }
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                } else {
                                                    amountFillIn = amountFillIn%20000
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                }
                                                
                                            } else {
                                                sheet20 = amountFillIn/20000
                                            }
                                        }
                                    } else {
                                        sheet50 = amountFillIn/50000
                                    }
                                } else {
                                    amountFillIn = amountFillIn%100000
                                    if amountFillIn/50000 >= 0 && amountFillIn%50000 > 0 {
                                        sheet50 = amountFillIn/50000
                                        if sheet50 >= sheets50Atm {
                                            sheet50 = sheets50Atm
                                            if sheet50 - sheets50Atm > 0 {
                                                amountFillIn = (sheet50 - sheets50Atm) * 50000
                                            }
                                            if amountFillIn/20000 >= 0 && amountFillIn%20000 > 0 {
                                                sheet20 = amountFillIn/20000
                                                if sheet20 >= sheets20Atm {
                                                    sheet20 = sheets20Atm
                                                    if sheet20 - sheets20Atm > 0 {
                                                        amountFillIn = (sheet20 - sheets20Atm) * 20000
                                                    }
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                } else {
                                                    amountFillIn = amountFillIn%20000
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                }
                                                
                                            } else {
                                                sheet20 = amountFillIn/20000
                                            }
                                        } else {
                                            amountFillIn = amountFillIn%50000
                                            if amountFillIn/20000 >= 0 && amountFillIn%20000 > 0 {
                                                sheet20 = amountFillIn/20000
                                                if sheet20 >= sheets20Atm {
                                                    sheet20 = sheets20Atm
                                                    if sheet20 - sheets20Atm > 0 {
                                                        amountFillIn = (sheet20 - sheets20Atm) * 20000
                                                    }
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                } else {
                                                    amountFillIn = amountFillIn%20000
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                }
                                                
                                            } else {
                                                sheet20 = amountFillIn/20000
                                            }
                                        }
                                    } else {
                                        sheet50 = amountFillIn/50000
                                    }
                                    
                                }
                            } else {
                                sheet100 = amountFillIn/100000
                            }
                        } else {
                            amountFillIn = amountFillIn%200000
                            if amountFillIn/100000 >= 0 && amountFillIn%100000 > 0 {
                                sheet100 = amountFillIn/100000
                                if sheet100 >= sheets100Atm {
                                    sheet100 = sheets100Atm
                                    if sheet100 - sheets100Atm > 0 {
                                        amountFillIn = (sheet100 - sheets100Atm) * 100000
                                    }
                                    if amountFillIn/50000 >= 0 && amountFillIn%50000 > 0 {
                                        sheet50 = amountFillIn/50000
                                        if sheet50 >= sheets50Atm {
                                            sheet50 = sheets50Atm
                                            if sheet50 - sheets50Atm > 0 {
                                                amountFillIn = (sheet50 - sheets50Atm) * 50000
                                            }
                                            if amountFillIn/20000 >= 0 && amountFillIn%20000 > 0 {
                                                sheet20 = amountFillIn/20000
                                                if sheet20 >= sheets20Atm {
                                                    sheet20 = sheets20Atm
                                                    if sheet20 - sheets20Atm > 0 {
                                                        amountFillIn = (sheet20 - sheets20Atm) * 20000
                                                    }
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                } else {
                                                    amountFillIn = amountFillIn%20000
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                }
                                                
                                            } else {
                                                sheet20 = amountFillIn/20000
                                            }
                                        } else {
                                            amountFillIn = amountFillIn%50000
                                            if amountFillIn/20000 >= 0 && amountFillIn%20000 > 0 {
                                                sheet20 = amountFillIn/20000
                                                if sheet20 >= sheets20Atm {
                                                    sheet20 = sheets20Atm
                                                    if sheet20 - sheets20Atm > 0 {
                                                        amountFillIn = (sheet20 - sheets20Atm) * 20000
                                                    }
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                } else {
                                                    amountFillIn = amountFillIn%20000
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                }
                                                
                                            } else {
                                                sheet20 = amountFillIn/20000
                                            }
                                        }
                                    } else {
                                        sheet50 = amountFillIn/50000
                                    }
                                } else {
                                    amountFillIn = amountFillIn%100000
                                    if amountFillIn/50000 >= 0 && amountFillIn%50000 > 0 {
                                        sheet50 = amountFillIn/50000
                                        if sheet50 >= sheets50Atm {
                                            sheet50 = sheets50Atm
                                            if sheet50 - sheets50Atm > 0 {
                                                amountFillIn = (sheet50 - sheets50Atm) * 50000
                                            }
                                            if amountFillIn/20000 >= 0 && amountFillIn%20000 > 0 {
                                                sheet20 = amountFillIn/20000
                                                if sheet20 >= sheets20Atm {
                                                    sheet20 = sheets20Atm
                                                    if sheet20 - sheets20Atm > 0 {
                                                        amountFillIn = (sheet20 - sheets20Atm) * 20000
                                                    }
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                } else {
                                                    amountFillIn = amountFillIn%20000
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                }
                                                
                                            } else {
                                                sheet20 = amountFillIn/20000
                                            }
                                        } else {
                                            amountFillIn = amountFillIn%50000
                                            if amountFillIn/20000 >= 0 && amountFillIn%20000 > 0 {
                                                sheet20 = amountFillIn/20000
                                                if sheet20 >= sheets20Atm {
                                                    sheet20 = sheets20Atm
                                                    if sheet20 - sheets20Atm > 0 {
                                                        amountFillIn = (sheet20 - sheets20Atm) * 20000
                                                    }
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                } else {
                                                    amountFillIn = amountFillIn%20000
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                }
                                                
                                            } else {
                                                sheet20 = amountFillIn/20000
                                            }
                                        }
                                    } else {
                                        sheet50 = amountFillIn/50000
                                    }
                                }
                                
                            } else {
                                sheet100 = amountFillIn/100000
                                
                            }
                        }
                    } else {
                        sheet200 = amountFillIn/200000
                    }
                } else {
                    amountFillIn = amountFillIn%500000
                    if amountFillIn/200000 >= 0 && amountFillIn%200000 > 0 {
                        sheet200 = amountFillIn/200000
                        if sheet200 >= sheets200Atm {
                            sheet200 = sheets200Atm
                            if sheet200 - sheets200Atm > 0 {
                                amountFillIn = (sheet200 - sheets200Atm) * 200000
                            }
                            if amountFillIn/100000 >= 0 && amountFillIn%100000 > 0 {
                                sheet100 = amountFillIn/100000
                                if sheet100 >= sheets100Atm {
                                    sheet100 = sheets100Atm
                                    if sheet100 - sheets100Atm > 0 {
                                        amountFillIn = (sheet100 - sheets100Atm) * 100000
                                    }
                                    if amountFillIn/50000 >= 0 && amountFillIn%50000 > 0 {
                                        sheet50 = amountFillIn/50000
                                        if sheet50 >= sheets50Atm {
                                            sheet50 = sheets50Atm
                                            if sheet50 - sheets50Atm > 0 {
                                                amountFillIn = (sheet50 - sheets50Atm) * 50000
                                            }
                                            if amountFillIn/20000 >= 0 && amountFillIn%20000 > 0 {
                                                sheet20 = amountFillIn/20000
                                                if sheet20 >= sheets20Atm {
                                                    sheet20 = sheets20Atm
                                                    if sheet20 - sheets20Atm > 0 {
                                                        amountFillIn = (sheet20 - sheets20Atm) * 20000
                                                    }
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                } else {
                                                    amountFillIn = amountFillIn%20000
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                }
                                                
                                            } else {
                                                sheet20 = amountFillIn/20000
                                            }
                                        } else {
                                            amountFillIn = amountFillIn%50000
                                            if amountFillIn/20000 >= 0 && amountFillIn%20000 > 0 {
                                                sheet20 = amountFillIn/20000
                                                if sheet20 >= sheets20Atm {
                                                    sheet20 = sheets20Atm
                                                    if sheet20 - sheets20Atm > 0 {
                                                        amountFillIn = (sheet20 - sheets20Atm) * 20000
                                                    }
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                } else {
                                                    amountFillIn = amountFillIn%20000
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                }
                                                
                                            } else {
                                                sheet20 = amountFillIn/20000
                                            }
                                        }
                                    } else {
                                        sheet50 = amountFillIn/50000
                                    }
                                } else {
                                    amountFillIn = amountFillIn%100000
                                    if amountFillIn/50000 >= 0 && amountFillIn%50000 > 0 {
                                        sheet50 = amountFillIn/50000
                                        if sheet50 >= sheets50Atm {
                                            sheet50 = sheets50Atm
                                            if sheet50 - sheets50Atm > 0 {
                                                amountFillIn = (sheet50 - sheets50Atm) * 50000
                                            }
                                            if amountFillIn/20000 >= 0 && amountFillIn%20000 > 0 {
                                                sheet20 = amountFillIn/20000
                                                if sheet20 >= sheets20Atm {
                                                    sheet20 = sheets20Atm
                                                    if sheet20 - sheets20Atm > 0 {
                                                        amountFillIn = (sheet20 - sheets20Atm) * 20000
                                                    }
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                } else {
                                                    amountFillIn = amountFillIn%20000
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                }
                                                
                                            } else {
                                                sheet20 = amountFillIn/20000
                                            }
                                        } else {
                                            amountFillIn = amountFillIn%50000
                                            if amountFillIn/20000 >= 0 && amountFillIn%20000 > 0 {
                                                sheet20 = amountFillIn/20000
                                                if sheet20 >= sheets20Atm {
                                                    sheet20 = sheets20Atm
                                                    if sheet20 - sheets20Atm > 0 {
                                                        amountFillIn = (sheet20 - sheets20Atm) * 20000
                                                    }
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                } else {
                                                    amountFillIn = amountFillIn%20000
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                }
                                                
                                            } else {
                                                sheet20 = amountFillIn/20000
                                            }
                                        }
                                    } else {
                                        sheet50 = amountFillIn/50000
                                    }
                                }
                                
                            } else {
                                sheet100 = amountFillIn/100000
                            }
                        } else {
                            amountFillIn = amountFillIn%200000
                            if amountFillIn/100000 >= 0 && amountFillIn%100000 > 0 {
                                sheet100 = amountFillIn/100000
                                if sheet100 >= sheets100Atm {
                                    sheet100 = sheets100Atm
                                    if sheet100 - sheets100Atm > 0 {
                                        amountFillIn = (sheet100 - sheets100Atm) * 100000
                                    }
                                    if amountFillIn/50000 >= 0 && amountFillIn%50000 > 0 {
                                        sheet50 = amountFillIn/50000
                                        if sheet50 >= sheets50Atm {
                                            sheet50 = sheets50Atm
                                            if sheet50 - sheets50Atm > 0 {
                                                amountFillIn = (sheet50 - sheets50Atm) * 50000
                                            }
                                            if amountFillIn/20000 >= 0 && amountFillIn%20000 > 0 {
                                                sheet20 = amountFillIn/20000
                                                if sheet20 >= sheets20Atm {
                                                    sheet20 = sheets20Atm
                                                    if sheet20 - sheets20Atm > 0 {
                                                        amountFillIn = (sheet20 - sheets20Atm) * 20000
                                                    }
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                } else {
                                                    amountFillIn = amountFillIn%20000
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                }
                                                
                                            } else {
                                                sheet20 = amountFillIn/20000
                                            }
                                        } else {
                                            amountFillIn = amountFillIn%50000
                                            if amountFillIn/20000 >= 0 && amountFillIn%20000 > 0 {
                                                sheet20 = amountFillIn/20000
                                                if sheet20 >= sheets20Atm {
                                                    sheet20 = sheets20Atm
                                                    if sheet20 - sheets20Atm > 0 {
                                                        amountFillIn = (sheet20 - sheets20Atm) * 20000
                                                    }
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                } else {
                                                    amountFillIn = amountFillIn%20000
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                }
                                                
                                            } else {
                                                sheet20 = amountFillIn/20000
                                            }
                                        }
                                    } else {
                                        sheet50 = amountFillIn/50000
                                    }
                                } else {
                                    amountFillIn = amountFillIn%100000
                                    if amountFillIn/50000 >= 0 && amountFillIn%50000 > 0 {
                                        sheet50 = amountFillIn/50000
                                        if sheet50 >= sheets50Atm {
                                            sheet50 = sheets50Atm
                                            if sheet50 - sheets50Atm > 0 {
                                                amountFillIn = (sheet50 - sheets50Atm) * 50000
                                            }
                                            if amountFillIn/20000 >= 0 && amountFillIn%20000 > 0 {
                                                sheet20 = amountFillIn/20000
                                                if sheet20 >= sheets20Atm {
                                                    sheet20 = sheets20Atm
                                                    if sheet20 - sheets20Atm > 0 {
                                                        amountFillIn = (sheet20 - sheets20Atm) * 20000
                                                    }
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                } else {
                                                    amountFillIn = amountFillIn%20000
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                }
                                                
                                            } else {
                                                sheet20 = amountFillIn/20000
                                            }
                                        } else {
                                            amountFillIn = amountFillIn%50000
                                            if amountFillIn/20000 >= 0 && amountFillIn%20000 > 0 {
                                                sheet20 = amountFillIn/20000
                                                if sheet20 >= sheets20Atm {
                                                    sheet20 = sheets20Atm
                                                    if sheet20 - sheets20Atm > 0 {
                                                        amountFillIn = (sheet20 - sheets20Atm) * 20000
                                                    }
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                } else {
                                                    amountFillIn = amountFillIn%20000
                                                    if amountFillIn/10000 > 0 {
                                                        sheet10 = amountFillIn/10000
                                                        if sheet10 > sheets10Atm {
                                                            let alertView = CBAlertView(title: AppDefine.AppName,
                                                                                        message: AppDefine.moneyNotEnough,
                                                                                        delegate: self,
                                                                                        cancelButtonTitle: "Ok",
                                                                                        otherButtonTitles: nil)
                                                            alertView.show()
                                                        } else {
                                                            sheet10 = amountFillIn/10000
                                                        }
                                                    } else {
                                                        print("")
                                                    }
                                                }
                                                
                                            } else {
                                                sheet20 = amountFillIn/20000
                                            }
                                        }
                                    } else {
                                        sheet50 = amountFillIn/50000
                                    }
                                }
                                
                            } else {
                                sheet100 = amountFillIn/100000
                            }
                        }
                    } else {
                        sheet200 = amountFillIn/200000
                    }
                }
            } else {
                sheet500 = amountFillIn/500000
            }
            
            amountTransaction = "\(Int(moneyTextfield.text!))"
            print("numbercard: \(numberCard)")
            amountAccount = "\(Int(amountAccount)! - Int(moneyTextfield.text!)!)"
            print("^^^^^^^^^^^^^^^ \(amountTransaction)---------\(amountAccount)")
            
            print(sheet10) ; print("*")
            print(sheet20) ; print("*")
            print(sheet50) ; print("*")
            print(sheet100) ; print("*")
            print(sheet200) ; print("*")
            print(sheet500) ; print("*")
            getMoneyATM()
            getMoneyAccount()
            addHistory()
        }
    }
}
