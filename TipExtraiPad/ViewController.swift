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
        
        menuTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        menuTableView.registerNib(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: cellID)
        menuTableView.indicatorStyle = UIScrollViewIndicatorStyle.White

        itemTableView.dataSource = itemTableHandler
        itemTableView.delegate = itemTableHandler
        itemTableView.registerNib(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "itemCellID")
        itemTableView.separatorStyle = .None
        
        dummyCell = NSBundle.mainBundle().loadNibNamed("OrderCell", owner: self, options: nil)[0] as! OrderCell
        
        self.addOrder()
    }
    
    //MARK: Actions
    
    @IBAction func serviceSwitchToggled(sender: AnyObject) {
        
        menuTableView.hidden = !serviceSwitch.on
        detailView.hidden = !serviceSwitch.on
    }
    
    //MARK: Misc methods
    
    func addOrder() {
        
        let item1 = MenuItem(name: "VODKA MARTINI", price: 10.0, quantity: 1)
        let item2 = MenuItem(name: "SCREWDRIVER", price: 6.0, quantity: 2)
        let item3 = MenuItem(name: "ABITA PURPLEHAZE", price: 3.0, quantity: 4)
        
        let order1 = Order(orderNumber: "0252", customerName: "HUNTER WHITTLE", orderItems: [item1, item2])
        let order2 = Order(orderNumber: "0253", customerName: "JOHN JONES", orderItems: [item3])
        orderArray = [order1, order2]
        self.menuTableView.reloadData()
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
        itemTableHandler.order = cell.order
        itemTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return dummyCell.frame.size.height
    }
}

