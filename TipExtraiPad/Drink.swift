//
//  MenuItem.swift
//  TipExtraiPad
//
//  Created by Hunter Whittle on 7/22/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

class Drink: NSObject {
    
    var drinkID: NSNumber
    var quantity: Int
    var price: Float
    var name: String
    var imageURL: String
    
    convenience override init() {
        self.init(drinkDict:["id": 0, "qty": 0, "cost": 0.0, "name": "", "image": ""])
    }
    
    init(drinkDict: [String: AnyObject]) {
        self.drinkID = drinkDict["id"] as! NSNumber
        self.quantity = drinkDict["qty"] as! Int
        self.price = drinkDict["cost"] as! Float
        self.name = drinkDict["name"] as! String
        self.imageURL = drinkDict["image"] as! String
        super.init()
    }
}