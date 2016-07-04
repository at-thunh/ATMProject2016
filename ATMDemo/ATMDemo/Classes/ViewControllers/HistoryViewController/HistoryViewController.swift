//
//  HistoryViewController.swift
//  ATMDemo
//
//  Created by AsianTech on 6/30/16.
//  Copyright © 2016 AsianTech. All rights reserved.
//

import UIKit
import RealmS

class HistoryViewController: UIViewController {
    private var historyData: Results<History>?
    @IBOutlet private weak var tableView: UITableView!
    private var heightTable = CGFloat(44)
    var numberCard = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Setup Data
    func setUpData() {
        historyData = RealmS().objects(History)
    }
    
    //MARK: Setup UI
    func setUpUI() {
        tableView.registerNib(HistoryCell.identifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Action
    @IBAction func clickHome(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
}

//MARK: TABLE
extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return heightTable
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (historyData?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(HistoryCell.identifier, forIndexPath: indexPath) as? HistoryCell
        let item = historyData![indexPath.row]
        cell?.viewData(item)
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = historyData![indexPath.row]
        var historyBill = HistoryBill()
        historyBill = (HistoryBill.loadBundle() as? HistoryBill)!
        historyBill.viewData(item)
        historyBill.frame = UIScreen.mainScreen().bounds
        self.navigationController?.view.addSubview(historyBill)
    }
}
