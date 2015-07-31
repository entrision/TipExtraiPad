//
//  ItemTableHandler.swift
//  TipExtraiPad
//
//  Created by Hunter Whittle on 7/22/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

class ItemTableHandler: NSObject {
    
    let cellID = "itemCellID"
    
    var dummyCell = ItemCell()
    var dummyHeader = ItemTableHeaderView()
    
    var order = Order()
    
    override init() {
        super.init()
        
        dummyCell = NSBundle.mainBundle().loadNibNamed("ItemCell", owner: self, options: nil)[0] as! ItemCell
        dummyHeader = NSBundle.mainBundle().loadNibNamed("ItemTableHeaderView", owner: self, options: nil)[0] as! ItemTableHeaderView
    }
}

extension ItemTableHandler: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order.orderItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! ItemCell
        
        let item = order.orderItems[indexPath.row] as! MenuItem
        cell.menuItem = item
        
        cell.selectionStyle = .None
        
        return cell
    }
}

extension ItemTableHandler: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return dummyCell.frame.size.height
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var headerView: ItemTableHeaderView?
        
        if section == 0 {
            headerView = NSBundle.mainBundle().loadNibNamed("ItemTableHeaderView", owner: self, options: nil)[0] as? ItemTableHeaderView
            headerView?.orderNumberLabel.text = "ORDER \(order.orderNumber)"
            headerView?.customerNameLabel.text = order.customerName
        }
        
        if let header = headerView {
            return header
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        var height: CGFloat = 0.0
        
        if section == 0 {
            height = dummyHeader.frame.size.height
        }
        
        return height
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        var footerView: UIView?
        
        if section == 0 {
            footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 1))
            footerView?.backgroundColor = UIColor.lightGrayColor()
        }
        
        if let footer = footerView {
            return footer
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var height: CGFloat = 0.0
        
        if section == 0 {
            height = 1.0
        }
        
        return height
    }
}