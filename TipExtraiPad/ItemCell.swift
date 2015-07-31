//
//  ItemCell.swift
//  TipExtraiPad
//
//  Created by Hunter Whittle on 7/22/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var theImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    
    var drink = Drink() {
        
        didSet {
            
            APIManager.getImage(drink.imageURL, success: { (theImage) -> () in
                self.theImageView.image = theImage
            }) { (error) -> () in
                println(error)
            }
            
            titleLabel.text = drink.name
            qtyLabel.text = "x \(drink.quantity)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        theImageView.layer.cornerRadius = theImageView.frame.size.width / 2
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
