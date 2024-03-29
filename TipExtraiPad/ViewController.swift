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
    var orderCount = 0
    
    var serviceSwitch = UISwitch()
    var orderFetchTimer = NSTimer()

    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var itemActivity: UIActivityIndicatorView!
    @IBOutlet weak var deliveredButton: ActivityButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "TIPEXTRA"
        
        orderTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        orderTableView.registerNib(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: cellID)
        orderTableView.indicatorStyle = UIScrollViewIndicatorStyle.White

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
        orderFetchTimer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: Selector("getOrders"), userInfo: nil, repeats: true)
    }
    
    //MARK: Actions
    
    @IBAction func deliveredButtonTapped(sender: AnyObject) {
        
        deliveredButton.startAnimating()
        APIManager.completeOrder(1, orderID: itemTableHandler.order.orderID, success: { (responseStatus, responseDict) -> () in
            self.deliveredButton.stopAnimating()
            self.getOrders()
        }) { (error) -> () in
            self.deliveredButton.stopAnimating()
            print(error)
        }
    }
    
    func serviceSwitchToggled() {
        
        if !serviceSwitch.on {
            orderView.hidden = true
            detailView.hidden = true
            orderFetchTimer.invalidate()
        }
        
        showToggleActivityIndicator()
        APIManager.toggleService(1, serviceOn: serviceSwitch.on, success: { (responseStatus, responseDict) -> () in
            self.hideToggleActivityIndicator(self.serviceSwitch.on)
            if responseStatus == Utils.kSuccessStatus {
                if self.serviceSwitch.on {
                    self.orderView.hidden = false
                    self.detailView.hidden = false
                    self.orderFetchTimer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: Selector("getOrders"), userInfo: nil, repeats: true)
                }
            } else {
                let message = responseDict.valueForKey("message") as! String
                self.showErrorAlertWithTitle("Uh oh!", theMessage: message)
            }
        }) { (error) -> () in
            print(error)
        }
    }
    
    //MARK: Misc methods

    func getOrders() {
        APIManager.getOrders(1, success: { (responseStatus, responseArray) -> () in
            self.orderArray = responseArray as! [Order]
            if self.orderArray.count > 0 {
                if self.orderArray.count > self.orderCount {    //new orders were added
                    self.orderCount = self.orderArray.count
                    self.orderTableView.hidden = false
                    var rowIndex = 0
                    if self.itemTableHandler.order.orderItems?.count > 0 {
                        if let theRowIndexPath = self.orderTableView.indexPathForSelectedRow {
                            if theRowIndexPath.row == self.orderTableView.numberOfRowsInSection(0) - 1 {
                                rowIndex = theRowIndexPath.row + 1
                            } else {
                                rowIndex = theRowIndexPath.row
                            }
                        }
                    }
                    self.orderTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.orderTableView.selectRowAtIndexPath(NSIndexPath(forRow: rowIndex, inSection: 0), animated: false, scrollPosition: .Top)
                        self.handleSelectAtIndexPath(NSIndexPath(forRow: rowIndex, inSection: 0))
                    })
                } else if self.orderArray.count < self.orderCount {     //order was delivered
                    self.orderCount = self.orderArray.count
                    self.orderTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.orderTableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: false, scrollPosition: .Top)
                        self.handleSelectAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
                    })
                }
            } else {
                self.orderTableView.hidden = true
                self.itemTableHandler.order = Order()
                self.itemTableView.reloadData()
                self.deliveredButton.enabled = false
                self.deliveredButton.alpha = 0.5
            }
            
        }) { (error) -> () in
            print(error)
        }
    }
    
    func handleSelectAtIndexPath(indexPath: NSIndexPath) {
        let cell = orderTableView.cellForRowAtIndexPath(indexPath) as! OrderCell
        
        if itemTableHandler.order.orderID == cell.order.orderID {
            return
        }
        
        itemTableView.hidden = true
        deliveredButton.enabled = false
        APIManager.getFullOrder(1, orderID: cell.order.orderID, success: { (responseStatus, responseDict) -> () in
            self.itemTableView.hidden = false
            self.deliveredButton.enabled = true
            self.deliveredButton.alpha = 1.0
            let order = cell.order
            order.orderItems = responseDict["order_items"] as? NSArray
            self.itemTableHandler.order = order
            self.itemTableView.reloadData()
        }) { (error) -> () in
            print(error)
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
        let alert = UIAlertController(title: theTitle, message: theMessage, preferredStyle: UIAlertControllerStyle.Alert)
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! OrderCell
        
        let order = orderArray[indexPath.row] as! Order
        cell.order = order
        
        cell.selectionStyle = .None
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        handleSelectAtIndexPath(indexPath)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return dummyCell.frame.size.height
    }
}

