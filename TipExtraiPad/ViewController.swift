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

    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var serviceSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        menuTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        menuTableView.registerNib(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: cellID)

        itemTableView.dataSource = itemTableHandler
        itemTableView.delegate = itemTableHandler
        itemTableView.registerNib(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "itemCellID")
        itemTableView.separatorStyle = .None
        
        dummyCell = NSBundle.mainBundle().loadNibNamed("OrderCell", owner: self, options: nil)[0] as! OrderCell
    }
    
    //MARK: Actions
    
    @IBAction func serviceSwitchToggled(sender: AnyObject) {
        
        menuTableView.hidden = !serviceSwitch.on
        detailView.hidden = !serviceSwitch.on
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! OrderCell
        
        cell.selectionStyle = .None
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return dummyCell.frame.size.height
    }
}

