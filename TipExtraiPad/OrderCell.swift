//
//  OrderCell.swift
//  TipExtraiPad
//
//  Created by Hunter Whittle on 7/22/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var order = Order()  {
        
        didSet {
            titleLabel.text = "ORDER \(order.orderID) | \(order.customerName)"
            priceLabel.text = String(format: "$%.2f", order.orderTotal)
            var drinksText = order.drinkTotal > 1 ? "DRINKS" : "DRINK"
            quantityLabel.text = "\(order.drinkTotal) \(drinksText)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        if self.selected == selected {
            return
        }
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            mainView.backgroundColor = Colors.tipExtraBlue
        } else {
            mainView.backgroundColor = UIColor(white: 0.05, alpha: 1.0)
        }
        
    }
    
}
