//
//  ViewController.swift
//  TipExtraiPad
//
//  Created by Hunter Whittle on 7/22/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let cellID = "orderCellID"
    
    var dummyCell = OrderCell()
    var itemTableHandler = ItemTableHandler()
    var orderArray = NSArray()

    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var serviceSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "TIPEXTRA"
        
        menuTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        menuTableView.registerNib(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: cellID)
        menuTableView.indicatorStyle = UIScrollViewIndicatorStyle.White

        itemTableView.dataSource = itemTableHandler
        itemTableView.delegate = itemTableHandler
        itemTableView.registerNib(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "itemCellID")
        itemTableView.separatorStyle = .None
        
        dummyCell = NSBundle.mainBundle().loadNibNamed("OrderCell", owner: self, options: nil)[0] as! OrderCell
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        getOrders()
//        NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: Selector("getOrders"), userInfo: nil, repeats: true)
    }
    
    //MARK: Actions
    
    @IBAction func serviceSwitchToggled(sender: AnyObject) {
        
        if !serviceSwitch.on {
            menuTableView.hidden = true
            detailView.hidden = true
        }
        
        APIManager.toggleService(1, serviceOn: serviceSwitch.on, success: { (responseStatus, responseDict) -> () in
            
            if responseStatus == Utils.kSuccessStatus {
                if self.serviceSwitch.on {
                    self.menuTableView.hidden = false
                    self.detailView.hidden = false
                }
            } else {
                let message = responseDict.valueForKey("message") as! String
                self.showErrorAlertWithTitle("Uh oh!", theMessage: message)
            }
        }) { (error) -> () in
            println(error)
        }
    }
    
    //MARK: Misc methods

    func getOrders() {
        APIManager.getOrders(1, success: { (responseStatus, responseArray) -> () in
            self.orderArray = responseArray as! [Order]
            self.menuTableView.reloadData()
        }) { (error) -> () in
            println(error)
        }
    }
    
    func showErrorAlertWithTitle(theTitle: String, theMessage: String) {
        var alert = UIAlertController(title: theTitle, message: theMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! OrderCell
        
        let order = orderArray[indexPath.row] as! Order
        cell.order = order
        
        cell.selectionStyle = .None
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = menuTableView.cellForRowAtIndexPath(indexPath) as! OrderCell
        
        APIManager.getFullOrder(1, orderID: cell.order.orderID, success: { (responseStatus, responseDict) -> () in
            let order = cell.order
            order.orderItems = responseDict["order_items"] as? NSArray
            self.itemTableHandler.order = order
            self.itemTableView.reloadData()
        }) { (error) -> () in
            println(error)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return dummyCell.frame.size.height
    }
}

