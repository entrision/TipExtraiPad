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
    
    override init() {
        super.init()
        
        dummyCell = NSBundle.mainBundle().loadNibNamed("ItemCell", owner: self, options: nil)[0] as! ItemCell
    }
}

extension ItemTableHandler: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! ItemCell
        
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
}