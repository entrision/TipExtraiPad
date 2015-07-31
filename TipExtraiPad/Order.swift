//
//  Order.swift
//  TipExtraiPad
//
//  Created by Hunter Whittle on 7/22/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

class Order: NSObject {
    
    var orderID: NSNumber
    var orderTotal: Float
    var drinkTotal: Int
    var customerName: String
    var orderItems: NSArray?
    
    convenience override init() {
        self.init(orderDict:["id": 0, "order_total": 0.0, "drink_total": 0, "customer_name": ""])
    }
    
    init(orderDict: [String: AnyObject]) {
        self.orderID = orderDict["id"] as! NSNumber
        self.orderTotal = orderDict["order_total"] as! Float
        self.drinkTotal = orderDict["drink_total"] as! Int
        self.customerName = orderDict["customer_name"] as! String
        super.init()
    }
}
