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
    
    var serviceSwitch = UISwitch()

    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var itemActivity: UIActivityIndicatorView!
    @IBOutlet weak var deliveredButton: ActivityButton!
    
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
        
        serviceSwitch = UISwitch(frame: CGRectMake(0, 0, 50, 30))
        serviceSwitch.addTarget(self, action: Selector("serviceSwitchToggled"), forControlEvents: UIControlEvents.ValueChanged)
        serviceSwitch.on = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: serviceSwitch)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        getOrders()
//        NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: Selector("getOrders"), userInfo: nil, repeats: true)
    }
    
    //MARK: Actions
    
    @IBAction func deliveredButtonTapped(sender: AnyObject) {
        
        deliveredButton.startAnimating()
        APIManager.completeOrder(1, orderID: itemTableHandler.order.orderID, success: { (responseStatus, responseDict) -> () in
            self.deliveredButton.stopAnimating()
        }) { (error) -> () in
            self.deliveredButton.stopAnimating()
            println(error)
        }
    }
    
    func serviceSwitchToggled() {
        
        if !serviceSwitch.on {
            orderView.hidden = true
            detailView.hidden = true
        }
        
        showToggleActivityIndicator()
        APIManager.toggleService(1, serviceOn: serviceSwitch.on, success: { (responseStatus, responseDict) -> () in
            self.hideToggleActivityIndicator(self.serviceSwitch.on)
            if responseStatus == Utils.kSuccessStatus {
                if self.serviceSwitch.on {
                    self.orderView.hidden = false
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
            if self.orderArray.count > 0 {
                self.deliveredButton.alpha = 1.0
                self.deliveredButton.enabled = true
                self.menuTableView.hidden = false
                self.menuTableView.reloadData()
            } else {
                self.deliveredButton.alpha = 0.5
                self.deliveredButton.enabled = false
                self.menuTableView.hidden = true
            }
            
        }) { (error) -> () in
            println(error)
        }
    }
    
    func showToggleActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 30, 30))
        activityIndicator.activityIndicatorViewStyle = .White
        activityIndicator.startAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
    }
    
    func hideToggleActivityIndicator(isOn: Bool) {
        serviceSwitch = UISwitch(frame: CGRectMake(0, 0, 50, 30))
        serviceSwitch.addTarget(self, action: Selector("serviceSwitchToggled"), forControlEvents: UIControlEvents.ValueChanged)
        serviceSwitch.on = isOn
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: serviceSwitch)
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
        
        if itemTableHandler.order.orderID == cell.order.orderID {
            return
        }
        
        itemTableView.hidden = true
        APIManager.getFullOrder(1, orderID: cell.order.orderID, success: { (responseStatus, responseDict) -> () in
            self.itemTableView.hidden = false
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

