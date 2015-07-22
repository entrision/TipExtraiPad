//
//  MenuItem.swift
//  TipExtraiPad
//
//  Created by Hunter Whittle on 7/22/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

class MenuItem: NSObject {
    
    var name: String = ""
    var price: Float = 0.0
    var ordered: Bool = false
    var quantity: Int = 0
    
    convenience override init() {
        self.init(name:"", price:0.0, quantity:0)
    }
    
    init(name: String, price: Float, quantity: Int) {
        super.init()
        self.name = name
        self.price = price
        self.quantity = quantity
    }
}