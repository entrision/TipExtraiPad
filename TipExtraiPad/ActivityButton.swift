//
//  ActivityButton.swift
//  TipExtraiPad
//
//  Created by Hunter Whittle on 8/3/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit

class ActivityButton: UIButton {
    
    var activityIndicator = UIActivityIndicatorView()
    var theTitle = ""
    
    var initialized = false
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !initialized {
            activityIndicator = UIActivityIndicatorView(frame: self.bounds)
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
            self.addSubview(activityIndicator)
            
            initialized = true
        }
    }
    
    func startAnimating() {
        enabled = false
        theTitle = self.currentTitle!
        self.setTitle("", forState: .Normal)
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        enabled = true
        self.setTitle(theTitle, forState: .Normal)
        activityIndicator.stopAnimating()
    }
}