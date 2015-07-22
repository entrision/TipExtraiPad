//
//  Order.swift
//  TipExtraiPad
//
//  Created by Hunter Whittle on 7/22/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

class Order: NSObject {
    
    var orderNumber: String
    var customerName: String
    var orderItems = NSArray()
    var total: Float {
        
        get {
            var theTotal: Float = 0.0
            for var i=0; i<orderItems.count; i++ {
                let menuItem = orderItems[i] as! MenuItem
                theTotal += menuItem.price * Float(menuItem.quantity)
            }
            return theTotal
        }
    }
    
    convenience override init() {
        self.init(orderNumber: "", customerName: "", orderItems: [])
    }
    
    init(orderNumber: String, customerName: String, orderItems: NSArray) {
        self.orderNumber = orderNumber
        self.customerName = customerName
        self.orderItems = orderItems
        super.init()
    }
}
